---
sidebar_position: 2
---

# Security Notions

## Standard hash function security

For a hash function $H: \{0,1\}^* \to \{0,1\}^n$:

- **Preimage resistance**: given $y$, find $x$ such that $H(x) = y$. Cost should
  be $O(2^n)$.
- **Second preimage resistance**: given $x$, find $x' \neq x$ such that
  $H(x) = H(x')$. Cost should be $O(2^n)$.
- **Collision resistance**: find any $x \neq x'$ such that $H(x) = H(x')$. Cost
  should be $O(2^{n/2})$ (birthday bound).

## Security for AO hash functions over $\mathbb{F}_p$

When the hash function operates over $\mathbb{F}_p$, the security is bounded by
$\lceil \log_2 p \rceil$ bits per field element in the capacity.

For a sponge with capacity $c$ field elements over $\mathbb{F}_p$ where
$\lceil \log_2 p \rceil = \ell$:

- **Collision resistance**: $\min(c \cdot \ell / 2, \, \text{target})$ bits
- **Preimage resistance**: $\min(c \cdot \ell, \, \text{target})$ bits

## Permutation security

The underlying permutation $\pi: \mathbb{F}_p^t \to \mathbb{F}_p^t$ should
behave as a **random permutation**. Concretely:

- No structural distinguisher faster than $O(2^{t \cdot \ell / 2})$
- No shortcut for inverting $\pi$ (needed for preimage attacks on the sponge)

## Algebraic security criteria

Beyond classical notions, AO permutations must resist algebraic attacks. The key
metrics are:

### Algebraic degree

After $r$ rounds, the output should have **maximal algebraic degree** as a
polynomial in the input variables. If the degree grows too slowly, the
permutation is vulnerable to higher-order differential attacks.

### Number of monomials

The number of monomials in the polynomial representation should grow
exponentially with the number of rounds.

### Groebner basis complexity

Solving the system of polynomial equations $\pi(x) = y$ using Groebner basis
methods should require $O(2^n)$ operations, where $n$ is the security parameter.

See the [attacks section](../attacks/) for detailed treatment of each criterion.
