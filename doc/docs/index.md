---
sidebar_position: 0
slug: /
---

# Arithmetization-Oriented Hash Functions

This is a research wiki on the security of **arithmetization-oriented (AO) hash
functions**, hash functions designed for efficient evaluation inside arithmetic
circuits, zero-knowledge proof systems, and other algebraic settings.

## Scope

Traditional hash functions (SHA-256, BLAKE3, Keccak) are designed for efficient
evaluation on CPUs. They rely on bitwise operations (XOR, AND, bit rotation)
that are cheap in hardware but expensive inside arithmetic circuits over large
prime fields $\mathbb{F}_p$.

AO hash functions replace bitwise operations with **field arithmetic**:
multiplications, exponentiations, and linear maps over $\mathbb{F}_p$. This
makes them orders of magnitude more efficient inside SNARKs, STARKs, and other
proof systems, but it also changes the threat model. The security analysis of
these primitives requires algebraic cryptanalysis, a different toolset from the
classical differential/linear methods used for AES or SHA.

## Primitives covered

| Primitive                                             | S-box                         | Structure                        | Year |
| ----------------------------------------------------- | ----------------------------- | -------------------------------- | ---- |
| [Poseidon](primitives/poseidon)                       | $x^{\alpha}$                  | SPN (full + partial rounds)      | 2019 |
| [Poseidon2](primitives/poseidon2)                     | $x^{\alpha}$                  | SPN (external + internal rounds) | 2023 |
| [Neptune](primitives/neptune)                         | $x^{\alpha}$                  | SPN (Poseidon variant)           | 2021 |
| [Anemoi](primitives/anemoi)                           | Flystel                       | SPN (open Flystel)               | 2022 |
| [Griffin](primitives/griffin)                         | $x^{\alpha}$ / $x^{1/\alpha}$ | Horst                            | 2022 |
| [Rescue / Rescue-Prime](primitives/rescue)            | $x^{\alpha}$ / $x^{1/\alpha}$ | SPN                              | 2020 |
| [Reinforced Concrete](primitives/reinforced-concrete) | Bars + Bricks + Concrete      | SPN (lookup-friendly)            | 2022 |
| [Tip5](primitives/tip5)                               | Lookup + $x^{\alpha}$         | SPN (Tip4Prime successor)        | 2023 |

## Analysis dimensions

Each primitive is studied along three axes:

### Arithmetization efficiency

The [arithmetization section](arithmetization/) covers the constraint cost of
evaluating each primitive inside the three main proof system families:

- [R1CS](arithmetization/r1cs) (Groth16, Spartan, Marlin)
- [AIR](arithmetization/air) (STARKs)
- [PlonK-ish](arithmetization/plonkish) (PLONK, Halo 2, HyperPlonk)

### CPU efficiency

The [CPU efficiency section](cpu-efficiency/) analyses the native performance
of each primitive outside of circuits: field arithmetic costs, the expense of
inverse S-boxes, and the impact of field choice on throughput.

### Cryptanalysis

The [attacks section](attacks/) covers the cryptanalytic techniques used to
evaluate these primitives:

- [Algebraic attacks](attacks/algebraic-attacks) (interpolation, invariant
  subspace)
- [Groebner basis attacks](attacks/groebner-basis)
- [Differential cryptanalysis](attacks/differential)
- [Higher-order differentials and algebraic degree](attacks/algebraic-degree)
- [Statistical attacks](attacks/statistical) (linear, integral)

## Sage code

All Sage scripts live in the `sage/` directory at the repository root. They are
referenced from the documentation pages and can be executed independently:

```bash
cd sage/poseidon
sage permutation.sage
```

## References

Papers are tracked using [papyrus](https://github.com/dannywillems/papyrus).
Each primitive page includes a chronological list of relevant publications with
links to the original papers and to
[cryptography.academy](https://cryptography.academy) where available.
