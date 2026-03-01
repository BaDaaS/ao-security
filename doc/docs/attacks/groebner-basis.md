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

Consider a permutation $\pi: \mathbb{F}_p^t \to \mathbb{F}_p^t$ built from $r$
rounds. Each round $i$ applies an S-box layer $S$, a linear layer $M$, and adds
round constants $c^{(i)}$. We introduce intermediate state variables
$s^{(0)}, s^{(1)}, \ldots, s^{(r)}$ where $s^{(0)} = (x_1, \ldots, x_t)$ is the
input and $s^{(r)} = (y_1, \ldots, y_t)$ is the output.

The round function produces the system:

$$
s^{(i)} = M \cdot S(s^{(i-1)}) + c^{(i)}, \quad i = 1, \ldots, r
$$

For a power map S-box $S(x) = x^{\alpha}$, expanding each round gives $t$
polynomial equations of degree $\alpha$:

$$
s_j^{(i)} = \sum_{k=1}^{t} M_{j,k} \cdot \left(s_k^{(i-1)}\right)^{\alpha} + c_j^{(i)}, \quad j = 1, \ldots, t
$$

The full system has:

- **Variables**: $t \cdot (r + 1)$ field elements (the $t$ state elements at
  each of the $r + 1$ layers, including input and output)
- **Equations**: $t \cdot r$ polynomial equations (one per state element per
  round), each of degree $\alpha$
- **Constraints**: the output $s^{(r)}$ is fixed to the known hash value

A **preimage attack** fixes $(y_1, \ldots, y_t)$ and solves for
$(x_1, \ldots, x_t)$. The intermediate variables $s^{(1)}, \ldots, s^{(r-1)}$
are unknowns that get eliminated during Groebner basis computation.

For **partial rounds** (Poseidon), only one equation per round has degree
$\alpha$; the remaining $t - 1$ are linear ($s_j^{(i)} = s_j^{(i-1)}$ through
the identity). This produces a sparser system with fewer high-degree equations,
which is precisely what makes it potentially easier to solve.

## Solving algorithms

### Buchberger's algorithm

The original algorithm (1965) for computing Groebner bases. It iteratively
computes **S-polynomials** (combinations that cancel leading terms) and reduces
them against the current basis. Conceptually simple but impractical for large
systems due to intermediate expression swell.

### F4 (Faugere, 1999)

F4 replaces the pairwise S-polynomial reductions of Buchberger with **sparse
linear algebra on Macaulay matrices**. In each step:

1. Select pairs of polynomials and form their S-polynomials
2. Construct a matrix where rows correspond to polynomial multiples and columns
   to monomials
3. Row-reduce this matrix using sparse linear algebra
4. Extract new basis elements from the reduced rows

The key insight: reducing many S-polynomials simultaneously via matrix
operations is far more efficient than reducing them one by one. F4 is the
workhorse algorithm used in practice (Magma, SageMath).

### F5 (Faugere, 2002)

F5 improves on F4 by detecting and **avoiding useless reductions** before they
happen. It maintains "signatures" that track the history of each polynomial,
allowing it to predict when an S-polynomial will reduce to zero (and thus skip
it).

The signature criterion guarantees:

- No redundant computation: every reduction produces new information
- The algorithm terminates with a Groebner basis without ever reducing to zero

For regular systems, F5 reaches the theoretical optimal solving degree. In
practice, F5 is harder to implement efficiently than F4, and many
implementations use F4 with heuristic redundancy elimination instead.

### XL (eXtended Linearization)

XL (Courtois et al., 2000) takes a different approach. Instead of iteratively
building a basis, it:

1. **Extend**: multiply each equation by all monomials up to some degree $D$,
   generating new equations
2. **Linearize**: treat each monomial as an independent variable
3. **Solve**: apply Gaussian elimination on the resulting linear system

If the degree $D$ is chosen large enough that the number of equations exceeds
the number of monomials, the linearized system is overdetermined and solvable.

The required degree $D$ is related to the solving degree of the Groebner basis
computation. XL is conceptually simpler than F4/F5 but typically requires the
same or higher degree, making it no more efficient in the generic case. However,
variants like **XL with Wiedemann** are useful for systems where the Macaulay
matrix is very sparse.

### Comparison

| Algorithm | Strategy                             | Strengths                                  |
| --------- | ------------------------------------ | ------------------------------------------ |
| F4        | Matrix reduction of S-polynomials    | Fast in practice, mature implementations   |
| F5        | Signature-based redundancy avoidance | Theoretically optimal, no zero reductions  |
| XL        | Linearization at fixed degree        | Simple to analyze, good for sparse systems |

## Solving degree and complexity

The cost of computing a Groebner basis depends on the **solving degree**
$D_{\text{sol}}$, which is the maximum degree reached during the computation.

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
- Faugere. "A New Efficient Algorithm for Computing Groebner Bases without
  Reduction to Zero (F5)" (2002)
- Courtois, Klimov, Patarin, Shamir. "Efficient Algorithms for Solving
  Overdefined Systems of Multivariate Polynomial Equations" (EUROCRYPT 2000)
- Bariant, Peyrin. "Algebraic Attacks against Some Arithmetization-Oriented
  Primitives" (2022)
- Keller, Rosemarin. "STARK Friendly Hash Survey" (2020)
