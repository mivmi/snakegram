use aes::cipher::generic_array::GenericArray;
use aes::cipher::{BlockDecrypt, BlockEncrypt, KeyInit, KeyIvInit, StreamCipher};
use pyo3::{exceptions::PyValueError, prelude::*, types::PyBytes, PyResult};
use rand::RngCore;
use sha1::{Digest, Sha1};

type Aes256CtrBE = ctr::Ctr128BE<aes::Aes256>;

pub fn ige256_encrypt(
    plain_text: &[u8],
    key: &[u8],
    iv: &[u8],
    hash: bool,
) -> Result<Vec<u8>, &'static str> {
    if key.len() != 32 {
        return Err("Invalid key length: Key must be 32 bytes");
    };

    if iv.len() != 32 {
        return Err("Invalid iv length: Iv must be 32 bytes");
    };

    let key = GenericArray::from_slice(key);

    let mut buffer = {
        let mut data = if hash {
            // prefix the `plain-text` with sha1 hash
            let mut result = Sha1::digest(plain_text).to_vec();
            result.extend_from_slice(plain_text);
            result
        } else {
            plain_text.to_vec()
        };

        // padding data to match the block size
        let remainder = data.len() % 16;
        if remainder != 0 {
            let mut rng = rand::thread_rng();
            let mut padding = vec![0u8; 16 - remainder];
            rng.fill_bytes(&mut padding);
            data.extend_from_slice(&padding);
        }

        data
    };

    let mut iv1 = [0u8; 16];
    let mut iv2 = [0u8; 16];

    iv1.copy_from_slice(&iv[..16]);
    iv2.copy_from_slice(&iv[16..]);

    let cipher = aes::Aes256::new(key);
    let mut result: Vec<u8> = Vec::new();

    for plain_block in buffer.chunks_mut(16) {
        let mut chunk = [0; 16];

        for i in 0..16 {
            chunk[i] = plain_block[i] ^ iv1[i];
        }

        let mut block = GenericArray::from_mut_slice(&mut chunk);
        cipher.encrypt_block(&mut block);

        for i in 0..16 {
            iv1[i] = block[i] ^ iv2[i];
        }
        result.extend_from_slice(&iv1);
        iv2.copy_from_slice(&plain_block);
    }
    Ok(result)
}

pub fn ige256_decrypt(
    cipher_text: &[u8],
    key: &[u8],
    iv: &[u8],
    hash: bool,
) -> Result<Vec<u8>, String> {
    if key.len() != 32 {
        let message = format!("Invalid key length: expected 32 bytes, got {}", key.len());

        return Err(message);
    };

    if iv.len() != 32 {
        let message = format!("Invalid iv length: expected 32 bytes, got {}", iv.len());
        return Err(message);
    };

    let length = cipher_text.len();
    if length % 16 != 0 {
        let message = "cipher-text length must be a multiple of 16";

        return Err(message.to_string());
    };
    let key = GenericArray::from_slice(key);

    let mut iv1 = [0u8; 16];
    let mut iv2 = [0u8; 16];
    let mut result = Vec::new();
    let mut buffer = cipher_text.to_vec();

    iv1.copy_from_slice(&iv[..16]);
    iv2.copy_from_slice(&iv[16..]);

    let cipher = aes::Aes256::new(key);

    for cipher_block in buffer.chunks_mut(16) {
        let mut chunk = [0; 16];

        for i in 0..16 {
            chunk[i] = cipher_block[i] ^ iv2[i];
        }

        let mut block = GenericArray::from_mut_slice(&mut chunk);
        cipher.decrypt_block(&mut block);

        for i in 0..16 {
            iv2[i] = block[i] ^ iv1[i];
        }

        result.extend_from_slice(&iv2);
        iv1.copy_from_slice(&cipher_block);
    }

    // hash verification
    if hash {
        if result.len() < 20 {
            let message = "Decrypted data is too short to verify sha1 hash.";
            return Err(message.to_string());
        }

        let (hash, mut plain_text) = result.split_at(20);

        let length = plain_text.len();
        let mut verified = false;
        for padding in 0..16 {
            if length <= padding {
                break;
            }
            let slice = &plain_text[..length - padding];
            if Sha1::digest(&slice).as_slice() == hash {
                verified = true;
                plain_text = slice;
                break;
            }
        }

        if !verified {
            let message = "hash verification failed: data may be corrupted or key is incorrect.";
            return Err(message.to_string());
        }
        result = plain_text.to_vec();
    };

    Ok(result)
}

#[pyclass]
pub struct Aes256Ctr {
    cipher: Aes256CtrBE,
}

#[pymethods]
impl Aes256Ctr {
    #[new]
    fn new(key: &[u8], nonce: &[u8]) -> PyResult<Self> {
        if key.len() != 32 {
            return Err(PyValueError::new_err(
                "Invalid key length: Key must be 32 bytes",
            ));
        }
        if nonce.len() != 16 {
            return Err(PyValueError::new_err(
                "Invalid nonce length: Nonce must be 16 bytes",
            ));
        }

        let key = GenericArray::from_slice(key);
        let nonce = GenericArray::from_slice(nonce);

        Ok(Aes256Ctr {
            cipher: Aes256CtrBE::new(&key, &nonce),
        })
    }

    #[pyo3(signature = (data))]
    fn __call__(&mut self, py: pyo3::Python, data: &[u8]) -> PyResult<Py<PyBytes>> {
        let mut buf = data.to_vec();
        self.cipher.apply_keystream(&mut buf);
        Ok(PyBytes::new(py, &buf).into())
    }
}

#[pyclass]
pub struct Aes256Ige {
    key: Vec<u8>,
    iv: Vec<u8>,
}

#[pymethods]
impl Aes256Ige {
    #[new]
    fn new(key: &[u8], iv: &[u8]) -> PyResult<Self> {
        if key.len() != 32 {
            return Err(PyValueError::new_err(
                "Invalid key length: Key must be 32 bytes",
            ));
        }
        if iv.len() != 32 {
            return Err(PyValueError::new_err(
                "Invalid iv length: Iv must be 32 bytes",
            ));
        }

        Ok(Aes256Ige {
            key: key.to_vec(),
            iv: iv.to_vec(),
        })
    }

    #[pyo3(signature = (plain_text, hash=false))]
    fn encrypt(&mut self, py: Python, plain_text: &[u8], hash: bool) -> PyResult<Py<PyBytes>> {
        match ige256_encrypt(&plain_text, &self.key, &self.iv, hash) {
            Ok(v) => Ok(PyBytes::new(py, &v).into()),
            Err(e) => Err(PyValueError::new_err(e)),
        }
    }

    #[pyo3(signature = (cipher_text, hash=false))]
    fn decrypt(&mut self, py: Python, cipher_text: &[u8], hash: bool) -> PyResult<Py<PyBytes>> {
        match ige256_decrypt(&cipher_text, &self.key, &self.iv, hash) {
            Ok(v) => Ok(PyBytes::new(py, &v).into()),
            Err(e) => Err(PyValueError::new_err(e)),
        }
    }
}
