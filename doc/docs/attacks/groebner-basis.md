---
sidebar_position: 2
---

# Groebner Basis Attacks

## Overview

A **Groebner basis** is a particular generating set of a polynomial ideal that
enables systematic solving of systems of polynomial equations. For AO hash
functions, the permutation can be written as a system of polynomial equations
over $\mathbb{F}_p$, and computing a Groebner basis of this system is equivalent
to solving the permutation.

## The attack model

Given a permutation $\pi: \mathbb{F}_p^t \to \mathbb{F}_p^t$ defined by $r$
rounds, each round introducing equations of degree $\alpha$ (the S-box degree),
we can write:

$$
\pi(x_1, \ldots, x_t) = (y_1, \ldots, y_t)
$$

as a system of polynomial equations in the input variables $x_i$ and
intermediate round variables. A **preimage attack** fixes the $y_i$ and solves
for $x_i$.

## Solving degree and complexity

The cost of computing a Groebner basis (using F4, F5, or XL algorithms) depends
on the **solving degree** $D_{\text{sol}}$, which is the maximum degree reached
during the computation.

The complexity is:

$$
O\left(\binom{n + D_{\text{sol}}}{D_{\text{sol}}}^{\omega}\right)
$$

where $n$ is the number of variables and $\omega \approx 2.37$ is the linear
algebra exponent.

### Regularity and semi-regularity

For a **regular** system (generic dense polynomials), the solving degree equals
the **Castelnuovo-Mumford regularity**, which can be read from the Hilbert
series of the ideal.

The **semi-regular** assumption is that the system behaves like a generic system
of the same degree sequence. Under this assumption, the Hilbert series predicts
the solving degree:

$$
H(z) = \frac{\prod_{i=1}^{m} (1 - z^{d_i})}{(1 - z)^n}
$$

where $d_i$ are the degrees of the $m$ equations in $n$ variables. The solving
degree is the index of the first non-positive coefficient.

## Application to AO hash functions

The key question: does the specific structure of AO permutations (sparse
equations, partial rounds, specific S-box) make the system **easier** to solve
than a generic system of the same degree?

### Dedicated Groebner basis attacks

Several papers have shown that the polynomial systems arising from AO hash
functions are **not semi-regular** and can be solved faster:

- Bariant et al. (2022): improved attacks on Poseidon exploiting the partial
  round structure
- Keller and Rosemarin (2020): practical Groebner basis attacks on reduced-round
  Poseidon

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: Groebner basis on a toy system
# (illustrative - real attacks use much larger fields)
p = 101
F = GF(p)
R = PolynomialRing(F, 'x,y,z', order='degrevlex')
x, y, z = R.gens()

# Toy 1-round system: S-box x^5, simple linear layer
alpha = 5
# Round: apply S-box then add constants
f1 = x^alpha + 2*y^alpha + 3*z^alpha - 42
f2 = 3*x^alpha + y^alpha + 2*z^alpha - 17
f3 = 2*x^alpha + 3*y^alpha + z^alpha - 89

I = R.ideal([f1, f2, f3])
print("Computing Groebner basis...")
G = I.groebner_basis()
print(f"Groebner basis has {len(G)} elements")
for g in G:
    print(f"  degree {g.degree()}: {g}")
`} />
<!-- prettier-ignore-end -->

## References

- Buchberger. "An Algorithm for Finding the Basis Elements of the Residue Class
  Ring of a Zero Dimensional Polynomial Ideal" (1965)
- Faugere. "A New Efficient Algorithm for Computing Groebner Bases (F4)" (1999)
- Bariant, Peyrin. "Algebraic Attacks against Some Arithmetization-Oriented
  Primitives" (2022)
- Keller, Rosemarin. "STARK Friendly Hash Survey" (2020)
