use crate::aes;

use aes::ige256_encrypt;
use num_bigint::BigUint;
use rand::RngCore;
use sha2::Sha256;
use sha1::{Digest, Sha1};

use pyo3::{exceptions::PyValueError, prelude::*, types::PyBytes, PyResult};
use rsa::{pkcs1::DecodeRsaPublicKey, traits::PublicKeyParts, RsaPublicKey};

fn to_bytes(value: &[u8]) -> Vec<u8> {
    let length = value.len();
    let mut result = Vec::new();

    if length < 254 {
        result.push(length as u8);
    } else {
        result.push(0xFE);
        result.extend_from_slice(&(length as u32).to_le_bytes()[..3]);
    }

    result.extend_from_slice(value);

    let padding_length = (4 - (result.len() % 4)) % 4;
    if padding_length > 0 {
        result.extend(std::iter::repeat(0x00).take(padding_length));
    }
    result
}

#[pyclass]
pub struct PublicKey {
    n: BigUint,
    e: BigUint,
    fingerprint: i64,
}

#[pymethods]
impl PublicKey {
    #[new]
    #[pyo3(signature = (pem))]
    fn new(pem: &str) -> PyResult<Self> {
        let key = RsaPublicKey::from_pkcs1_pem(pem)
            .map_err(|e| PyValueError::new_err(format!("{:?}", e)))?;

        let n = key.n().to_bytes_be();
        let e = key.e().to_bytes_be();

        let mut sha1 = Sha1::new();

        sha1.update(&to_bytes(&n));
        sha1.update(&to_bytes(&e));

        let result = sha1.finalize();
        let mut fingerprint = [0u8; 8];
        fingerprint.copy_from_slice(&result[result.len() - 8..]);

        Ok(PublicKey {
            n: BigUint::from_bytes_be(&n),
            e: BigUint::from_bytes_be(&e),
            fingerprint: i64::from_le_bytes(fingerprint),
        })
    }

    // https://core.telegram.org/mtproto/auth_key#41-rsa-paddata-server-public-key-mentioned-above-is-implemented-as-follows
    #[pyo3(signature = (plain_text))]
    fn encrypt(&self, plain_text: &[u8]) -> PyResult<Py<PyBytes>> {
        if plain_text.len() > 144 {
            return Err(PyValueError::new_err("plain_text is too long > 144"));
        }
        let mut rng = rand::thread_rng();
        let padding_length = 192 - plain_text.len();
        let mut data_with_padding = plain_text.to_vec();

        if padding_length > 0 {
            let mut padding = vec![0u8; padding_length];
            rng.fill_bytes(&mut padding);
            data_with_padding.extend_from_slice(&padding);
        }

        let mut data_pad_reversed = data_with_padding.clone();
        data_pad_reversed.reverse();

        loop {
            let mut key = [0u8; 32];
            rng.fill_bytes(&mut key);

            let mut hasher = Sha256::new();

            hasher.update(&key);
            hasher.update(&data_with_padding);

            let mut data = data_pad_reversed.clone();
            data.extend(hasher.finalize());

            let aes_encrypted = match ige256_encrypt(&data, &key, &[0u8; 32], false) {
                Ok(v) => v,
                Err(e) => {
                    return Err(PyValueError::new_err(e));
                }
            };

            let hash_encrypted = Sha256::digest(&aes_encrypted).to_vec();

            let mut buffer: Vec<u8> = key
                .iter()
                .zip(hash_encrypted.iter())
                .map(|(a, b)| a ^ b)
                .collect();

            buffer.extend_from_slice(&aes_encrypted);

            let key_num = num_bigint::BigUint::from_bytes_be(&buffer);

            if self.n > key_num {
                if buffer.len() < 255 {
                    let padding_length = 255 - buffer.len();

                    if padding_length > 0 {
                        let mut padding = vec![0u8; padding_length];
                        rng.fill_bytes(&mut padding);
                        buffer.extend_from_slice(&padding);

                    }
                }

                let m = BigUint::from_bytes_be(&buffer);

                // ciphertext = m ^ e mod n
                let c = m.modpow(&self.e, &self.n);

                return Python::with_gil(|py| Ok(PyBytes::new(py, &c.to_bytes_be()).into()));
            }
        }
    }

    #[getter]
    fn n(&self) -> PyResult<BigUint> {
        Ok(self.n.clone())
    }

    #[getter]
    fn e(&self) -> PyResult<BigUint> {
        Ok(self.e.clone())
    }

    #[getter]
    fn fingerprint(&self) -> PyResult<i64> {
        Ok(self.fingerprint)
    }

    fn __repr__(&self) -> String {
        format!("<PublicKey: {}>", self.fingerprint.to_string())
    }
}
