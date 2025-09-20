mod aes;
mod math;
mod public_key;

use aes::{Aes256Ctr, Aes256Ige};
use math::math_module;
use public_key::PublicKey;

use pyo3::{prelude::*, wrap_pymodule};

#[pymodule]
pub fn crypto(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_wrapped(wrap_pymodule!(math_module))?;

    m.add_class::<Aes256Ctr>()?;
    m.add_class::<Aes256Ige>()?;
    m.add_class::<PublicKey>()?;

    Ok(())
}
