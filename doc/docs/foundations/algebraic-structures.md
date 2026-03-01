---
sidebar_position: 1
---

# Algebraic Structures

## Finite fields

An AO hash function operates over a prime field
$\mathbb{F}_p = \mathbb{Z}/p\mathbb{Z}$. All arithmetic (addition,
multiplication, inversion) is modulo a large prime $p$, typically the scalar
field of an elliptic curve used in a proof system.

Common choices:

- **BN254 scalar field**:
  $p = 21888242871839275222246405745257275088548364400416034343698204186575808495617$
- **BLS12-381 scalar field**:
  $p = 52435875175126190479447740508185965837690552500527637822603658699938581184513$
- **Goldilocks**: $p = 2^{64} - 2^{32} + 1$
- **BabyBear**: $p = 2^{31} - 2^{27} + 1$

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: basic field arithmetic
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
a = F(42)
b = F(17)
print(f"a + b = {a + b}")
print(f"a * b = {a * b}")
print(f"a^(-1) = {a^(-1)}")
`} />
<!-- prettier-ignore-end -->

## S-boxes

The **S-box** (substitution box) is the nonlinear component of an AO hash
function. Unlike AES which uses lookup tables, AO S-boxes are defined by
algebraic expressions over $\mathbb{F}_p$.

### Power map S-box

The most common choice: $S(x) = x^{\alpha}$ where $\alpha$ is chosen so that
$\gcd(\alpha, p - 1) = 1$ (ensuring the map is a permutation).

Common values of $\alpha$:

| $\alpha$              | Used by                      |
| --------------------- | ---------------------------- |
| 3                     | Poseidon (some instances)    |
| 5                     | Poseidon, Poseidon2, Neptune |
| 7                     | Poseidon (some instances)    |
| $-1$ (i.e. $x^{p-2}$) | Rescue (inverse map)         |

The **algebraic degree** of $x^{\alpha}$ is $\alpha$, and the algebraic degree
of its inverse $x^{1/\alpha}$ is $1/\alpha \mod (p-1)$, which is typically very
large. This asymmetry is exploited by Rescue.

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: power map S-box
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
alpha = 5
# Verify gcd condition
assert gcd(alpha, p - 1) == 1
# Compute inverse exponent
alpha_inv = inverse_mod(alpha, p - 1)
print(f"alpha = {alpha}")
print(f"alpha_inv = {alpha_inv}")
# Verify S-box is a permutation
x = F(123456789)
assert F(x^alpha)^alpha_inv == x
print("S-box round-trip verified: S_inv(S(x)) == x")
`} />
<!-- prettier-ignore-end -->

### Flystel S-box (Anemoi)

Anemoi uses the **open Flystel** construction, a 2-to-2 map built from the power
map. See the [Anemoi page](../primitives/anemoi) for details.

## MDS matrices

A **Maximum Distance Separable (MDS)** matrix $M$ over $\mathbb{F}_p$ is used as
the linear layer. An $t \times t$ MDS matrix has the property that every square
submatrix is invertible. This ensures **full diffusion**: every output element
depends on every input element after one application of $M$.

MDS matrices are typically constructed as:

- **Cauchy matrices**: $M_{i,j} = 1/(x_i - y_j)$ for distinct elements
  $x_i, y_j \in \mathbb{F}_p$
- **Circulant matrices**: defined by a single row, used in Poseidon2
- **Vandermonde-based**: used in some Rescue variants

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: Cauchy MDS matrix
p = 101  # small prime for demonstration
F = GF(p)
t = 3
xs = [F(i) for i in range(t)]
ys = [F(i + t) for i in range(t)]
M = matrix(F, t, t, lambda i, j: 1 / (xs[i] - ys[j]))
print("Cauchy MDS matrix:")
print(M)
print(f"Determinant: {M.det()}")
# Verify all square submatrices are invertible
for size in range(1, t + 1):
    for rows in Combinations(range(t), size):
        for cols in Combinations(range(t), size):
            sub = M[rows, cols]
            assert sub.det() != 0, f"Singular submatrix at {rows}, {cols}"
print("All submatrices are invertible (MDS property verified)")
`} />
<!-- prettier-ignore-end -->

## Sponge construction

Most AO hash functions use the **sponge construction** to build a
variable-input-length hash from a fixed-width permutation $\pi$.

The state is split into:

- **Rate** $r$: absorbs input and squeezes output
- **Capacity** $c$: provides security; never directly exposed

The security level is $\min(2^{c/2}, 2^r)$ for collision resistance and
$\min(2^c, 2^r)$ for preimage resistance.

For AO hash functions, the state width is measured in **field elements**, not
bits. A state of $t$ elements over $\mathbb{F}_p$ has
$t \cdot \lceil \log_2 p \rceil$ bits.
