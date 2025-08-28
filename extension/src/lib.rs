use crypto::crypto;
use pyo3::{prelude::*, wrap_pymodule};

#[pymodule]
fn _rust(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_wrapped(wrap_pymodule!(crypto))?;
    Ok(())
}
