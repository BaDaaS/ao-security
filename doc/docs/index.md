---
sidebar_position: 0
slug: /
---

# Arithmetization-Oriented Hash Functions

This is a research wiki on the security of **arithmetization-oriented (AO)
cryptographic primitives**: hash functions, permutations, ciphers, and signature
schemes designed for efficient evaluation inside arithmetic circuits,
zero-knowledge proof systems, MPC protocols, and other algebraic settings.

## Context and motivation

This wiki is part of [BaDaaS](https://github.com/BaDaaS)'s research effort into
the cryptanalysis of AO constructions. It is related to the
[Poseidon initiative](https://www.poseidon-initiative.info/) by the Ethereum
Foundation, which coordinates security analysis of Poseidon and related
primitives used across the Ethereum ecosystem.

At BaDaaS, we are interested in the **cryptanalysis of AO constructions** across
the board. As a starting point for our research, we are building this **live
wiki** with:

- **Documentation** of all known AO primitive designs, their security claims,
  and the attacks published against them.
- **Sage code** providing reference implementations, attack reproductions, and
  algebraic experiments.
- **Industrial usage mapping** showing which primitives are deployed in which
  proof systems and protocols.
- **Resource gathering** from research papers, but also from textbooks on
  computational algebra, Groebner bases, and solving multivariate polynomial
  systems over finite fields, to identify whether unexplored mathematical
  landscapes could yield new cryptanalytic techniques.

## Scope

Traditional hash functions (SHA-256, BLAKE3, Keccak) are designed for efficient
evaluation on CPUs. They rely on bitwise operations (XOR, AND, bit rotation)
that are cheap in hardware but expensive inside arithmetic circuits over large
prime fields $\mathbb{F}_p$.

AO primitives replace bitwise operations with **field arithmetic**:
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
