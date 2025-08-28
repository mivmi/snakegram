mod aes;
mod math;
mod public_key;

use aes::{ctr256, ige256_decrypt, ige256_encrypt};
use math::math_module;
use public_key::PublicKey;

use pyo3::exceptions::PyValueError;
use pyo3::{prelude::*, types::PyBytes, wrap_pymodule};

macro_rules! wrap_pybytes {
    ($func:expr) => {{
        match $func {
            Ok(v) => Python::with_gil(|py| Ok(PyBytes::new(py, &v).into())),
            Err(e) => Err(PyValueError::new_err(e)),
        }
    }};
}

#[pyfunction]
fn aes_ctr256(data: &[u8], key: &[u8], nonce: &[u8]) -> PyResult<Py<PyBytes>> {
    wrap_pybytes!(ctr256(data, key, nonce))
}

#[pyfunction]
#[pyo3(signature = (plain_text, key, iv, hash=false))]
fn aes_ige256_encrypt(
    plain_text: &[u8],
    key: &[u8],
    iv: &[u8],
    hash: bool,
) -> PyResult<Py<PyBytes>> {
    wrap_pybytes!(ige256_encrypt(plain_text, key, iv, hash))
}

#[pyfunction]
#[pyo3(signature = (cipher_text, key, iv, hash=false))]
fn aes_ige256_decrypt(
    cipher_text: &[u8],
    key: &[u8],
    iv: &[u8],
    hash: bool,
) -> PyResult<Py<PyBytes>> {
    wrap_pybytes!(ige256_decrypt(cipher_text, key, iv, hash))
}

#[pymodule]
pub fn crypto(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_wrapped(wrap_pymodule!(math_module))?;
    m.add_function(wrap_pyfunction!(aes_ctr256, m)?)?;
    m.add_function(wrap_pyfunction!(aes_ige256_encrypt, m)?)?;
    m.add_function(wrap_pyfunction!(aes_ige256_decrypt, m)?)?;

    m.add_class::<PublicKey>()?;

    Ok(())
}
