---
sidebar_position: 7
---

# Reinforced Concrete

## Overview

**Reinforced Concrete** takes a fundamentally different approach from other AO
hash functions. Instead of using a single algebraic S-box, it combines three
different nonlinear operations: **Bars** (decomposition- based), **Bricks**
(power map), and **Concrete** (linear mixing).

- **Authors**: Grassi, Hao, Rechberger, Rot, Schofnegger, Walch
- **Year**: 2022
- **S-box**: Composite (Bars + Bricks)
- **Structure**: SPN with lookup-friendly nonlinear layer

## The Bars operation

The **Bars** operation decomposes a field element into its representation in a
smaller base and applies a lookup table to each "digit." This bridges the gap
between algebraic and lookup-based designs:

1. Decompose $x \in \mathbb{F}_p$ into base-$s$ digits:
   $x = \sum_i d_i \cdot s^i$
2. Apply a lookup table $T$ to each digit: $d_i' = T(d_i)$
3. Recompose: $x' = \sum_i d_i' \cdot s^i$

## Security implications

The Bars operation is specifically designed to:

- Have high algebraic degree (the decomposition/recomposition over a prime field
  has degree $\geq p - 1$ in general)
- Break the algebraic structure that Groebner basis attacks exploit
- Be efficient in lookup-based proof systems (Plookup, Caulk)

The tradeoff: Bars is harder to express in R1CS, making Reinforced Concrete most
efficient in lookup-friendly proof systems.

## References

- Grassi, Hao, Rechberger, Rot, Schofnegger, Walch. "Reinforced Concrete: A Fast
  Hash Function for Verifiable Computation" (CCS 2022)
  [ePrint 2021/1038](https://eprint.iacr.org/2021/1038)
