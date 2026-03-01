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

## Macaulay matrices

(See Macaulay.
["Some Properties of Enumeration in the Theory of Modular Systems"](https://doi.org/10.1112/plms/s2-26.1.531)
(Proc. London Math. Soc., 1927),
[Wikipedia: Macaulay matrix](https://en.wikipedia.org/wiki/Macaulay_matrix), and
Cox, Little, O'Shea.
["Ideals, Varieties, and Algorithms"](https://doi.org/10.1007/978-3-319-16721-3)
(Springer, 4th ed. 2015), Chapter 9.)

A **Macaulay matrix** is the central data structure in modern Groebner basis
algorithms. It encodes a system of polynomial equations as a matrix suitable for
linear algebra.

Given polynomials $f_1, \ldots, f_m$ in $n$ variables, the **degree-$D$ Macaulay
matrix** $\mathcal{M}_D$ is constructed as follows:

1. For each polynomial $f_i$ of degree $d_i$, multiply it by every monomial of
   degree $\leq D - d_i$. This produces new polynomials of degree $\leq D$.
2. List all monomials of degree $\leq D$ as column headers, ordered by the
   chosen monomial ordering (e.g., degrevlex).
3. Each row of the matrix is one polynomial (an original $f_i$ times a
   monomial), with entries being the coefficients of each monomial.

The matrix has:

- **Rows**: $\sum_{i=1}^{m} \binom{n + D - d_i}{D - d_i}$ (one row per
  polynomial-monomial product)
- **Columns**: $\binom{n + D}{D}$ (one column per monomial of degree $\leq D$)

**Row-reducing** $\mathcal{M}_D$ (Gaussian elimination) is equivalent to
computing all polynomial reductions up to degree $D$. When $D$ equals the
solving degree, the row echelon form reveals the Groebner basis.

The key observation for complexity: the matrix dimensions grow as
$\binom{n + D}{D}$, which is polynomial in $n$ for fixed $D$ but exponential in
$D$ for fixed $n$. This is why the solving degree $D_{\text{sol}}$ dominates the
cost.

<!-- prettier-ignore-start -->
<SageCell code={`
# Build and visualize a Macaulay matrix
p = 101
F = GF(p)
R.<x, y> = PolynomialRing(F, order='degrevlex')

# Two quadratic polynomials
f1 = x^2 + 3*x*y + 2*y^2 - 1
f2 = 2*x^2 + x*y + y^2 - 3

print(f"f1 = {f1}")
print(f"f2 = {f2}")

# Build Macaulay matrix at degree D=2 (no extension needed)
# At degree 2, we just use f1 and f2 directly
D = 2
# All monomials up to degree D
mons = [x^2, x*y, y^2, x, y, R(1)]
print(f"\nDegree-{D} Macaulay matrix")
print(f"Monomials: {mons}")

rows_polys = [f1, f2]
M2 = matrix(F, len(rows_polys), len(mons))
for i, poly in enumerate(rows_polys):
    for j, mon in enumerate(mons):
        M2[i, j] = poly.monomial_coefficient(mon)
print(f"\nM_2 ({M2.nrows()} x {M2.ncols()}):")
print(M2)

# Now extend to degree D=3: multiply each f_i by {1, x, y}
D = 3
mons3 = [x^3, x^2*y, x*y^2, y^3, x^2, x*y, y^2, x, y, R(1)]
multipliers = [R(1), x, y]

rows_polys3 = []
row_labels = []
for f, name in [(f1, 'f1'), (f2, 'f2')]:
    for m in multipliers:
        rows_polys3.append(m * f)
        row_labels.append(f"{m}*{name}")

M3 = matrix(F, len(rows_polys3), len(mons3))
for i, poly in enumerate(rows_polys3):
    for j, mon in enumerate(mons3):
        M3[i, j] = poly.monomial_coefficient(mon)

print(f"\nDegree-{D} Macaulay matrix")
print(f"Monomials: {mons3}")
print(f"Row labels: {row_labels}")
print(f"\nM_3 ({M3.nrows()} x {M3.ncols()}):")
print(M3)
print(f"Rank: {M3.rank()}")
print(f"\nRow echelon form:")
print(M3.echelon_form())
`} />
<!-- prettier-ignore-end -->

## S-polynomials

(See
[Wikipedia: Groebner basis](https://en.wikipedia.org/wiki/Gr%C3%B6bner_basis#Buchberger's_algorithm),
Cox, Little, O'Shea.
["Ideals, Varieties, and Algorithms"](https://doi.org/10.1007/978-3-319-16721-3)
(Springer, 4th ed. 2015), Chapter 2, and Buchberger.
["An Algorithm for Finding the Basis Elements of the Residue Class Ring of a Zero Dimensional Polynomial Ideal"](<https://doi.org/10.1016/S0747-7171(06)80016-2>)
(1965, English translation 2006).)

The **S-polynomial** (syzygy polynomial) is the fundamental operation in
Groebner basis algorithms. Given two polynomials $f$ and $g$ with leading
monomials $\text{LM}(f)$ and $\text{LM}(g)$, the S-polynomial is designed to
**cancel their leading terms**.

Let $L = \text{lcm}(\text{LM}(f), \text{LM}(g))$. The S-polynomial is:

$$
S(f, g) = \frac{L}{\text{LT}(f)} \cdot f - \frac{L}{\text{LT}(g)} \cdot g
$$

where $\text{LT}(f)$ is the leading term (coefficient times leading monomial).
The result has strictly lower degree than $L$ because the leading terms cancel
by construction.

**Why S-polynomials matter**: if all S-polynomials of pairs in a basis reduce to
zero, then the basis is a Groebner basis (this is Buchberger's criterion). If an
S-polynomial does not reduce to zero, its remainder is a new polynomial that
must be added to the basis. This is the core loop of Buchberger's algorithm.

<!-- prettier-ignore-start -->
<SageCell code={`
# S-polynomial computation
p = 101
F = GF(p)
R.<x, y, z> = PolynomialRing(F, order='degrevlex')

f = 2*x^3*y + 3*x*y^2 + 5
g = x^2*y^2 + 4*y^3 + 1

print(f"f = {f}")
print(f"g = {g}")
print(f"LM(f) = {f.lm()}")
print(f"LM(g) = {g.lm()}")

# Compute S-polynomial manually
L = lcm(f.lm(), g.lm())
print(f"lcm(LM(f), LM(g)) = {L}")

S_fg = (L // f.lt()) * f - (L // g.lt()) * g
print(f"\nS(f, g) = {S_fg}")
print(f"Degree of S(f,g): {S_fg.degree()}")
print(f"(Leading terms cancelled: degree dropped from {L.degree()})")

# Verify with Sage's built-in
# Compute Groebner basis of {f, g} to see S-polynomial reduction in action
I = R.ideal([f, g])
G = I.groebner_basis()
print(f"\nGroebner basis of <f, g>:")
for i, gi in enumerate(G):
    print(f"  g{i+1}: {gi}")
`} />
<!-- prettier-ignore-end -->

## Solving algorithms

### Buchberger's algorithm

(See
[Wikipedia: Buchberger's algorithm](https://en.wikipedia.org/wiki/Buchberger%27s_algorithm)
and Buchberger.
["An Algorithm for Finding the Basis Elements of the Residue Class Ring of a Zero Dimensional Polynomial Ideal"](<https://doi.org/10.1016/S0747-7171(06)80016-2>)
(1965, English translation 2006).)

The original algorithm (1965) for computing Groebner bases. It iteratively
computes S-polynomials of all pairs and reduces them against the current basis.
If a reduction yields a nonzero remainder, it is added to the basis and the
process repeats. The algorithm terminates when all S-polynomials reduce to zero.
Conceptually simple but impractical for large systems due to intermediate
expression swell: the polynomials generated during computation can have very
large coefficients and many terms, even if the final basis is compact.

### F4 (Faugere, 1999)

(See Faugere.
["A New Efficient Algorithm for Computing Groebner Bases (F4)"](<https://doi.org/10.1016/S0022-4049(99)00005-5>)
(Journal of Pure and Applied Algebra, 1999).)

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

#### Example: Groebner basis of a 1-round system

The following computes the Groebner basis of a toy 1-round AO system using
SageMath's default algorithm (a variant of F4). We solve a system where the
S-box is $x^5$ and the linear layer is a simple matrix over $\mathbb{F}_{101}$.

<!-- prettier-ignore-start -->
<SageCell code={`
# 1-round AO system over a small field
p = 101
F = GF(p)
R.<x, y, z> = PolynomialRing(F, order='degrevlex')
alpha = 5

# One round: S-box then linear mix then constants
# Output = M * S-box(input) + constants
# We set up equations: output is known, solve for input
f1 = x^alpha + 2*y^alpha + 3*z^alpha - 42
f2 = 3*x^alpha + y^alpha + 2*z^alpha - 17
f3 = 2*x^alpha + 3*y^alpha + z^alpha - 89

I = R.ideal([f1, f2, f3])
G = I.groebner_basis()

print(f"System: 3 equations of degree {alpha} in 3 variables over F_{p}")
print(f"Groebner basis has {len(G)} elements:\n")
for i, g in enumerate(G):
    print(f"  g{i+1} (degree {g.degree()}): {g}")

# The last element is univariate in z -> we can read off solutions
print(f"\nVariety (solutions):")
V = I.variety()
for sol in V:
    print(f"  x={sol[x]}, y={sol[y]}, z={sol[z]}")
`} />
<!-- prettier-ignore-end -->

#### Example: Macaulay matrix construction

F4 works by constructing **Macaulay matrices** from polynomial multiples and
row-reducing them. Here we build the degree-$D$ Macaulay matrix for a small
system to illustrate the linear algebra at the core of F4.

<!-- prettier-ignore-start -->
<SageCell code={`
# Illustrate the Macaulay matrix for a small system
p = 101
F = GF(p)
R.<x, y> = PolynomialRing(F, order='degrevlex')

# Simple system: two quadratic equations
f1 = x^2 + 3*x*y + 2*y^2 - 1
f2 = 2*x^2 + x*y + y^2 - 3

# Build Macaulay matrix at degree D=3
# Multiply each equation by all monomials up to degree D - deg(f_i)
D = 3
mons_D = R.monomials_of_degree(D) + R.monomials_of_degree(D-1) + R.monomials_of_degree(D-2) + R.monomials_of_degree(D-3)
# Get all monomials up to degree D, sorted by degrevlex
all_mons = sorted(set(mons_D), key=lambda m: (-m.degree(), str(m)))

# Multipliers for f1 (degree 2): multiply by monomials of degree <= 1
mult_f1 = [R(1), x, y]
# Multipliers for f2: same
mult_f2 = [R(1), x, y]

rows = []
for m in mult_f1:
    rows.append(m * f1)
for m in mult_f2:
    rows.append(m * f2)

# Build the matrix
M_mac = matrix(F, len(rows), len(all_mons))
for i, poly in enumerate(rows):
    for j, mon in enumerate(all_mons):
        M_mac[i, j] = poly.monomial_coefficient(mon)

print(f"Macaulay matrix at degree D={D}:")
print(f"  {M_mac.nrows()} rows (polynomial multiples)")
print(f"  {M_mac.ncols()} columns (monomials)")
print(f"  Rank: {M_mac.rank()}")
print(f"\nMonomials: {all_mons}")
print(f"\nMatrix:")
print(M_mac)

# Row-reduce to find the Groebner basis
print(f"\nRow echelon form:")
print(M_mac.echelon_form())
`} />
<!-- prettier-ignore-end -->

#### Example: scaling with rounds

As the number of rounds increases, the polynomial system grows and becomes
harder to solve. This example builds the system for a 2-round and 3-round
Poseidon-like permutation and measures the Groebner basis computation.

<!-- prettier-ignore-start -->
<SageCell code={`
import time

p = 101
F = GF(p)
alpha = 5
t = 2  # state width (small for tractability)

# MDS matrix
M = matrix(F, [[2, 1], [1, 3]])

def build_system(n_rounds):
    """Build polynomial system for n_rounds of a Poseidon-like permutation."""
    # Variables: input (layer 0) + intermediates (layers 1..n_rounds-1)
    n_vars = t * n_rounds  # intermediate + input vars (output is fixed)
    var_names = []
    for r in range(n_rounds):
        for j in range(t):
            var_names.append(f's{r}_{j}')
    R = PolynomialRing(F, var_names, order='degrevlex')
    vs = R.gens()

    # Group variables by round
    layers = []
    for r in range(n_rounds):
        layers.append([vs[r*t + j] for j in range(t)])

    # Fixed output (target)
    target = [F(42), F(17)]

    equations = []
    for r in range(1, n_rounds):
        # Round r: layers[r] = M * S-box(layers[r-1]) + constants
        sbox_out = [layers[r-1][j]^alpha for j in range(t)]
        for j in range(t):
            lhs = layers[r][j]
            rhs = sum(M[j,k] * sbox_out[k] for k in range(t)) + F(r*t + j + 1)
            equations.append(lhs - rhs)

    # Final round: target = M * S-box(layers[-1]) + constants
    sbox_out = [layers[-1][j]^alpha for j in range(t)]
    for j in range(t):
        rhs = sum(M[j,k] * sbox_out[k] for k in range(t)) + F(n_rounds*t + j + 1)
        equations.append(target[j] - rhs)

    return R, equations

for n_rounds in [2, 3, 4]:
    R, eqs = build_system(n_rounds)
    n_vars = len(R.gens())
    n_eqs = len(eqs)

    t0 = time.time()
    I = R.ideal(eqs)
    G = I.groebner_basis()
    elapsed = time.time() - t0

    print(f"Rounds: {n_rounds} | Vars: {n_vars} | Eqs: {n_eqs} | "
          f"GB size: {len(G)} | Max degree: {max(g.degree() for g in G)} | "
          f"Time: {elapsed:.3f}s")
`} />
<!-- prettier-ignore-end -->

### F5 (Faugere, 2002)

(See Faugere.
["A New Efficient Algorithm for Computing Groebner Bases without Reduction to Zero (F5)"](https://doi.org/10.1145/780506.780516)
(ISSAC 2002).)

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

(See Courtois, Klimov, Patarin, Shamir.
["Efficient Algorithms for Solving Overdefined Systems of Multivariate Polynomial Equations"](https://doi.org/10.1007/3-540-45539-6_27)
(EUROCRYPT 2000).)

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

### Hilbert series

(See
[Wikipedia: Hilbert series and Hilbert polynomial](https://en.wikipedia.org/wiki/Hilbert_series_and_Hilbert_polynomial),
Cox, Little, O'Shea.
["Ideals, Varieties, and Algorithms"](https://doi.org/10.1007/978-3-319-16721-3)
(Springer, 4th ed. 2015), Chapter 9, and Hilbert.
["Ueber die Theorie der algebraischen Formen"](https://doi.org/10.1007/BF01208503)
(Mathematische Annalen, 1890).)

The **Hilbert series** (or Hilbert-Poincare series) of a polynomial ideal $I$
encodes the dimensions of the graded components of the quotient ring $R/I$. For
a polynomial ring $R = \mathbb{F}_p[x_1, \ldots, x_n]$ and a homogeneous ideal
$I$, the Hilbert series is the formal power series:

$$
\text{HS}_{R/I}(z) = \sum_{d=0}^{\infty} \dim_{\mathbb{F}_p}(R/I)_d \cdot z^d
$$

where $(R/I)_d$ is the vector space of degree-$d$ elements in the quotient. In
concrete terms, the coefficient of $z^d$ counts the number of linearly
independent monomials of degree $d$ that are **not** in the ideal (i.e., they
are not leading monomials of any element of a Groebner basis).

For the free polynomial ring (no ideal), the Hilbert series is
$1/(1-z)^n = \sum_d \binom{n+d-1}{d} z^d$, which counts all monomials.

For a system of $m$ equations with degrees $d_1, \ldots, d_m$ in $n$ variables,
if the system is **regular** (see below), the Hilbert series has the closed
form:

$$
\text{HS}(z) = \frac{\prod_{i=1}^{m} (1 - z^{d_i})}{(1 - z)^n}
$$

Each factor $(1 - z^{d_i})$ in the numerator "subtracts" the monomials killed by
equation $i$. The denominator $(1 - z)^n$ accounts for the $n$ free variables.

**Why it matters for Groebner bases**: during the Groebner basis computation
(F4, F5), the algorithm processes polynomials degree by degree. At each degree
$d$, the number of new basis elements found corresponds to the drop in the
Hilbert function. When the Hilbert function reaches zero, the computation is
complete. The degree at which this happens is the solving degree.

<!-- prettier-ignore-start -->
<SageCell code={`
# Compute Hilbert series for a polynomial ideal
p = 101
F = GF(p)
R.<x, y, z> = PolynomialRing(F, order='degrevlex')

# System of 3 quadratic equations in 3 variables
f1 = x^2 + 2*y*z + 3
f2 = y^2 + x*z + 7
f3 = z^2 + x*y + 11

I = R.ideal([f1, f2, f3])

# Compute Groebner basis first
G = I.groebner_basis()
print(f"Groebner basis has {len(G)} elements")
print(f"Max degree in GB: {max(g.degree() for g in G)}")

# Hilbert series of the quotient ring R/I
# For zero-dimensional ideals, this is a polynomial (finite sum)
HS = R.quotient(I).hilbert_series()
print(f"\nHilbert series of R/I:")
print(f"  HS(z) = {HS}")

# The number of solutions equals HS(1)
print(f"\nHS(1) = {HS(1)} (number of solutions, counting multiplicity)")

# Predicted Hilbert series under regularity assumption
# For 3 equations of degree 2 in 3 variables:
# HS(z) = (1-z^2)^3 / (1-z)^3 = (1+z)^3 = 1 + 3z + 3z^2 + z^3
S.<z> = PowerSeriesRing(QQ, default_prec=10)
HS_predicted = prod(1 - z^2 for _ in range(3)) / (1 - z)^3
print(f"\nPredicted HS (regular assumption):")
print(f"  {HS_predicted}")
print(f"  First non-positive coeff at degree: ", end="")
for d, c in enumerate(HS_predicted.list()):
    if c <= 0:
        print(f"{d} (solving degree)")
        break
`} />
<!-- prettier-ignore-end -->

### Castelnuovo-Mumford regularity

(See
[Wikipedia: Castelnuovo-Mumford regularity](https://en.wikipedia.org/wiki/Castelnuovo%E2%80%93Mumford_regularity),
Bayer, Stillman.
["A criterion for detecting m-regularity"](https://doi.org/10.1007/BF01231893)
(Inventiones mathematicae, 1987), and Eisenbud.
["Commutative Algebra: with a View Toward Algebraic Geometry"](https://doi.org/10.1007/978-1-4612-5350-1)
(Springer, 1995), Chapter 20.)

The **Castelnuovo-Mumford regularity** (or simply "regularity") of a homogeneous
ideal $I$ is an algebraic invariant that, for our purposes, equals the **maximum
degree reached during an optimal Groebner basis computation**.

Formally, for a graded module $M$ over the polynomial ring, the regularity is
defined via the minimal free resolution:

$$
\text{reg}(M) = \max_i \{ j - i : \beta_{i,j}(M) \neq 0 \}
$$

where $\beta_{i,j}$ are the **graded Betti numbers** (they count generators in
position $i$ and degree $j$ of the resolution). This definition comes from
homological algebra, but its practical meaning is direct: the regularity tells
you the highest degree you will encounter when computing the Groebner basis.

For a **regular** system of $m = n$ homogeneous polynomials of degrees
$d_1, \ldots, d_n$ in $n$ variables, the regularity is:

$$
\text{reg} = 1 + \sum_{i=1}^{n} (d_i - 1)
$$

For example, 3 quadratic equations in 3 variables have regularity
$1 + 3 \cdot (2 - 1) = 4$.

### Regularity and semi-regularity

(See Bardet, Faugere, Salvy.
["On the complexity of Groebner basis computation of semi-regular overdetermined algebraic equations"](https://inria.hal.science/inria-00071534)
(INRIA RR-5049, 2003) for the semi-regularity notion, and Faugere.
["A New Efficient Algorithm for Computing Groebner Bases without Reduction to Zero (F5)"](https://doi.org/10.1145/780506.780516)
(2002) for the connection to solving degree.)

For a **regular** system (generic dense polynomials), the solving degree equals
the Castelnuovo-Mumford regularity, which can be read from the Hilbert series of
the ideal.

A system is **regular** if adding each equation to the ideal formed by the
previous ones always increases the ideal in the expected way (no "accidental"
algebraic relations). Equivalently, the sequence $f_1, \ldots, f_m$ is a regular
sequence in the polynomial ring.

The **semi-regular** assumption relaxes this: the system need not be a regular
sequence, but the Hilbert series should still match the prediction from the
degree sequence. Under this assumption, the Hilbert series predicts the solving
degree:

$$
H(z) = \frac{\prod_{i=1}^{m} (1 - z^{d_i})}{(1 - z)^n}
$$

where $d_i$ are the degrees of the $m$ equations in $n$ variables. The solving
degree is the index of the first non-positive coefficient.

The semi-regular assumption is widely used in cryptographic security estimates.
The key question for AO hash functions is whether their polynomial systems are
actually semi-regular, or whether the specific algebraic structure (sparse
equations, partial rounds) causes the solving degree to be lower than predicted.

## Application to AO hash functions

The key question: does the specific structure of AO permutations (sparse
equations, partial rounds, specific S-box) make the system **easier** to solve
than a generic system of the same degree?

### Dedicated Groebner basis attacks

Several papers have shown that the polynomial systems arising from AO hash
functions are **not semi-regular** and can be solved faster:

- [Bariant et al. (2022)](https://eprint.iacr.org/2022/1058): improved attacks
  on Poseidon exploiting the partial round structure
- [Keller and Rosemarin (2020)](https://eprint.iacr.org/2020/948): practical
  Groebner basis attacks on reduced-round Poseidon

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

- Buchberger.
  ["An Algorithm for Finding the Basis Elements of the Residue Class Ring of a Zero Dimensional Polynomial Ideal"](<https://doi.org/10.1016/S0747-7171(06)80016-2>)
  (1965, English translation 2006)
- Faugere.
  ["A New Efficient Algorithm for Computing Groebner Bases (F4)"](<https://doi.org/10.1016/S0022-4049(99)00005-5>)
  (1999)
- Faugere.
  ["A New Efficient Algorithm for Computing Groebner Bases without Reduction to Zero (F5)"](https://doi.org/10.1145/780506.780516)
  (2002)
- Courtois, Klimov, Patarin, Shamir.
  ["Efficient Algorithms for Solving Overdefined Systems of Multivariate Polynomial Equations"](https://doi.org/10.1007/3-540-45539-6_27)
  (EUROCRYPT 2000)
- Bariant, Peyrin.
  ["Algebraic Attacks against Some Arithmetization-Oriented Primitives"](https://eprint.iacr.org/2022/1058)
  (2022)
- Keller, Rosemarin.
  ["STARK Friendly Hash Survey"](https://eprint.iacr.org/2020/948) (2020)
