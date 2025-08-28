use pyo3::prelude::*;
use std::cmp::min;

use num_bigint::{BigInt, RandBigInt};
use rand::Rng;

fn gcd(mut a: u128, mut b: u128) -> u128 {
    if a < b {
        std::mem::swap(&mut a, &mut b);
    }

    while b != 0 {
        let temp = a % b;
        a = b;
        b = temp;
    }
    a
}

#[pyfunction]
#[pyo3(signature = (n, trials=8))]
fn is_prime(n: BigInt, trials: u32) -> bool {
    if n <= BigInt::from(1) {
        return false;
    }
    if n <= BigInt::from(3) {
        return true;
    }
    if (&n % 2u8) == BigInt::ZERO {
        return false;
    }

    // n - 1 = 2^r * d
    let mut r: u32 = 0;
    let mut d = &n - 1u8;

    while (&d % 2u8) == BigInt::ZERO {
        d /= 2u8;
        r += 1;
    }

    let mut rng = rand::thread_rng();
    let two = BigInt::from(2);

    'outer: for _ in 0..trials {
        let a = rng.gen_bigint_range(&two, &(&n - &two));

        let mut x = a.modpow(&d, &n);

        if x == BigInt::from(1) || x == &n - 1u8 {
            continue;
        }

        for _ in 0..r.saturating_sub(1) {
            x = x.modpow(&two, &n);
            if x == &n - 1 {
                continue 'outer;
            }
            if x == BigInt::from(1) {
                return false;
            }
        }
        return false;
    }
    true
}


#[pyfunction]
pub fn factorization(pq: i64) -> (i64, i64) {
    if pq <= 2 {
        return (1, pq);
    }
    if pq % 2 == 0 {
        return (2, (pq / 2));
    }

    let pq = pq as u128;

    let mut rng = rand::thread_rng();
    let mut x = 0u128;
    let mut ys = 0u128;
    let mut g = 1u128;
    let mut r = 1u128;
    let mut q = 1u128;
    let y = rng.gen_range(1..pq) as u128;
    let c = rng.gen_range(1..pq) as u128;
    let m = rng.gen_range(1..pq) as u128;

    let mut y = y;

    while g == 1 {
        x = y;
        for _ in 0..r {
            y = (y.wrapping_mul(y) + c) % pq;
        }

        let mut k = 0u128;
        while k < r && g == 1 {
            ys = y;
            for _ in 0..min(m, r - k) {
                y = (y.wrapping_mul(y) + c) % pq;
                q = (q * x.abs_diff(y)) % pq;
            }
            g = gcd(q, pq);
            k += m;
        }

        r *= 2;
    }

    if g == pq {
        loop {
            ys = (ys.wrapping_mul(ys) + c) % pq;
            g = gcd(x.abs_diff(ys), pq);
            if g > 1 {
                break;
            }
        }
    }

    let (p, q) = (g, pq / g);
    if p < q {
        (p as i64, q as i64)
    } else {
        (q as i64, p as i64)
    }
}

#[pymodule]
#[pyo3(name = "math")]
pub fn math_module(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(is_prime, m)?)?;
    m.add_function(wrap_pyfunction!(factorization, m)?)?;

    Ok(())
}
