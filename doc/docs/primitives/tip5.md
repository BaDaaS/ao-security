---
sidebar_position: 8
---

# Tip5

## Overview

**Tip5** (and its predecessor Tip4Prime) is designed for the Triton VM and
STARK-based proof systems. It combines a **lookup-based** S-box with a power
map, optimized for the Goldilocks field ($p = 2^{64} - 2^{32} + 1$).

- **Authors**: STARK ecosystem developers
- **Year**: 2023
- **S-box**: Lookup table + $x^{\alpha}$
- **Structure**: SPN optimized for Goldilocks field

## Design rationale

Tip5 targets the Goldilocks field where:

- $x^7$ is used as the algebraic S-box
- A lookup table of size $2^{16}$ provides additional nonlinearity
- The combination is designed for efficient evaluation in the Triton VM

## Goldilocks-specific optimizations

The Goldilocks field $p = 2^{64} - 2^{32} + 1$ allows:

- Fast multiplication using the special form of $p$
- Efficient decomposition for the lookup component
- The S-box $x^7$ has $\gcd(7, p-1) = 1$ (verified for Goldilocks)

## Security considerations

The lookup table component makes pure Groebner basis analysis harder, as the
lookup has no simple polynomial description. The security argument combines:

- Algebraic analysis of the $x^7$ component
- Statistical properties of the lookup table
- Interaction between the two nonlinear layers

## References

- [Tip5 specification](https://eprint.iacr.org/2023/107)
- Alan Szepieniec.
  ["The Tip5 Hash Function for the Triton VM"](https://eprint.iacr.org/2023/107)
  (2023)
