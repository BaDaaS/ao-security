---
sidebar_position: 4
---

# Algebraic Degree and Higher-Order Differentials

## Algebraic degree

The **algebraic degree** of a function $f: \mathbb{F}_p^t \to \mathbb{F}_p$ is
the maximum total degree of its polynomial representation. For a permutation
$\pi = (\pi_1, \ldots, \pi_t)$, the algebraic degree is $\max_i \deg(\pi_i)$.

## Higher-order differentials

The $k$-th order differential of $f$ is obtained by iterating the differential
operator $k$ times. A key property:

$$
\Delta^{(d+1)} f = 0 \quad \text{if } \deg(f) = d
$$

This means: if the algebraic degree of the permutation after $r$ rounds is $d$,
then the $(d+1)$-th order differential is zero. If $d$ is small enough that
$\binom{t}{d+1}$ evaluations are feasible, this gives a **distinguisher**.

## Degree growth in AO hash functions

For a single full round with S-box $x^{\alpha}$ and MDS mixing:

- After 1 round: degree $\leq \alpha$
- After 2 rounds: degree $\leq \alpha^2$
- After $r$ rounds: degree $\leq \alpha^r$ (upper bound)

The actual degree can be lower due to:

1. **Partial rounds** (Poseidon): only one element gets the S-box, so the degree
   increase per partial round is slower
2. **Degree cancellation**: the algebraic structure may cause terms to cancel,
   reducing the effective degree below $\alpha^r$

### The degree estimation problem

A central open question in AO hash function security: does the actual degree
match the upper bound $\alpha^r$, or does it fall short?

If the actual degree is significantly lower than $\alpha^r$, the number of
rounds needed for security increases. Several papers have studied this for
specific constructions:

- Grassi et al. showed that Poseidon's partial rounds have slower degree growth
  than the naive bound suggests
- Bariant et al. gave tighter degree bounds for the partial round structure

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: degree growth experiment on small state
p = 101
F = GF(p)
alpha = 5
t = 3  # state width

R = PolynomialRing(F, ['x%d' % i for i in range(t)])
xs = R.gens()

def sbox_full(state):
    return [x^alpha for x in state]

def sbox_partial(state):
    return [state[0]^alpha] + list(state[1:])

# Simple MDS: circulant matrix [2, 1, 1]
def mds(state):
    return [
        2*state[0] + state[1] + state[2],
        state[0] + 2*state[1] + state[2],
        state[0] + state[1] + 2*state[2],
    ]

def add_constants(state, r):
    return [s + F(r * t + i + 1) for i, s in enumerate(state)]

# Track degree through rounds
state = list(xs)
print("Round | Degree")
print("------+-------")
for r in range(6):
    # Full round
    state = sbox_full(state)
    state = mds(state)
    state = add_constants(state, r)
    max_deg = max(s.degree() for s in state)
    print(f"  {r+1:3d} | {max_deg}")
`} />
<!-- prettier-ignore-end -->

## References

- Lai. "Higher Order Derivatives and Differential Cryptanalysis" (1994)
- Grassi. "Algebraic Degree of Poseidon" (2021)
- Bariant et al. "Algebraic Attacks on AO Primitives" (2022)
