---
sidebar_position: 5
---

# Statistical Attacks

## Linear cryptanalysis

Linear cryptanalysis finds approximate **linear relations** between input and
output bits (or field elements). For a function
$f: \mathbb{F}_p^t \to \mathbb{F}_p^t$, a linear approximation is:

$$
\sum_{i} a_i \cdot x_i \approx \sum_{j} b_j \cdot f(x)_j
$$

with some **bias** $\varepsilon$ from uniform. The attack requires
$O(1/\varepsilon^2)$ known input-output pairs.

For power map S-boxes $x^{\alpha}$ over large $\mathbb{F}_p$, the linear bias is
$O(1/\sqrt{p})$ by the Weil bound. This makes pure linear cryptanalysis
infeasible for large primes.

## Integral / square attack

The **integral attack** exploits the algebraic structure directly. Choose a set
of inputs where some coordinates vary over all values in a subfield or subspace,
while others are fixed. If the sum (integral) over the output set is predictable
(e.g., zero), this gives a distinguisher.

For AO hash functions, the integral property is closely related to algebraic
degree: a function of degree $d$ satisfies

$$
\sum_{x \in V} f(x) = 0
$$

for any subspace $V$ of dimension $> d$ (over $\mathbb{F}_2$, this is exact;
over $\mathbb{F}_p$ the relationship is more nuanced).

## Boomerang and rectangle attacks

These are differential-based techniques that combine two short differential
trails into a longer distinguisher. Their relevance to AO hash functions is
limited compared to algebraic attacks, but they have been studied for
completeness in security analyses of Rescue and Anemoi.

## References

- Matsui.
  ["Linear Cryptanalysis Method for DES Cipher"](https://doi.org/10.1007/3-540-48285-7_33)
  (EUROCRYPT 1993)
- Knudsen, Wagner.
  ["Integral Cryptanalysis"](https://doi.org/10.1007/3-540-45473-X_8) (FSE 2002)
- Grassi et al. ["Rescue"](https://eprint.iacr.org/2020/1143) (2020), Section on
  statistical properties
