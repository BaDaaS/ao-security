---
sidebar_position: 0
---

# Arithmetization

This section introduces the three main **arithmetization schemes** used in
modern proof systems and analyses the constraint efficiency of AO hash
functions inside each of them.

Arithmetization schemes are also commonly referred to as the **frontend** of a
proof system. The frontend translates a high-level computation (here, a hash
function evaluation) into a system of polynomial constraints. The **backend**
then takes those constraints and produces a cryptographic proof. When we say a
hash function is "efficient in R1CS" or "optimised for PlonK-ish", we are
talking about the cost at the frontend level.

## Why arithmetization matters

A proof system encodes a computation as a system of polynomial constraints over
a finite field $\mathbb{F}_p$. The "cost" of evaluating a hash function inside
a proof is measured in the number of constraints (or equivalent metric)
produced by its arithmetization. AO hash functions are designed specifically to
minimise this cost.

Different proof systems use different constraint languages:

| Arithmetization                        | Used by                        | Constraint shape                          | Cost metric             |
| -------------------------------------- | ------------------------------ | ----------------------------------------- | ----------------------- |
| [R1CS](arithmetization/r1cs)           | Groth16, Spartan, Marlin       | $A \cdot B = C$ (rank-1 bilinear)         | Number of R1CS gates    |
| [AIR](arithmetization/air)             | STARKs (Winterfell, Stone)     | Transition polynomials over trace columns | Trace width x length    |
| [PlonK-ish](arithmetization/plonkish)  | PLONK, Halo 2, HyperPlonk     | Custom gates + copy constraints           | Number of rows (gates)  |

The same hash function can have very different costs depending on the
arithmetization. For example, Poseidon's partial rounds save many R1CS
constraints but yield smaller savings in PlonK-ish systems where custom gates
absorb more operations per row.

## Key takeaways

- **R1CS** penalises every non-linear operation equally (one constraint per
  multiplication gate), so minimising the total number of multiplications is
  the primary optimisation target.
- **AIR** and **PlonK-ish** both allow higher-degree constraints, so
  operations like $x \mapsto x^{1/\alpha}$ (the inverse S-box in Rescue) can
  be verified with a single constraint $y^{\alpha} = x$ at no extra cost. The
  same custom gate works in both settings.
- **PlonK-ish** systems additionally support **lookup arguments** that make
  table-based S-boxes (Reinforced Concrete, Tip5) very cheap.

## References

- Ben-Sasson, Bentov, Horesh, Riabzev. "Scalable, transparent, and
  post-quantum secure computational integrity" (2018)
  [ePrint 2018/046](https://eprint.iacr.org/2018/046)
- Gabizon, Williamson, Ciobotaru. "PLONK: Permutations over Lagrange-bases
  for Oecumenical Noninteractive arguments of Knowledge" (2019)
  [ePrint 2019/953](https://eprint.iacr.org/2019/953)
- Groth. "On the Size of Pairing-based Non-interactive Arguments" (EUROCRYPT
  2016) [ePrint 2016/260](https://eprint.iacr.org/2016/260)
