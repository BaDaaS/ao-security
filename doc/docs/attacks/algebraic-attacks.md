---
sidebar_position: 1
---

# Algebraic Attacks

## Interpolation attack

The **interpolation attack** (Jakobsen and Knudsen, 1997) exploits the fact that
the cipher (or permutation) can be expressed as a polynomial of low degree over
$\mathbb{F}_p$.

If the permutation $\pi: \mathbb{F}_p \to \mathbb{F}_p$ after $r$ rounds can be
represented as a polynomial of degree $d$, then $d + 1$ input-output pairs
suffice to recover the polynomial via Lagrange interpolation. The attack is
feasible when $d < p$.

### Complexity

For an S-box $S(x) = x^{\alpha}$ with $t$-element state and $r$ full rounds, the
degree of the output polynomial in the input is at most $\alpha^r$ (before
reduction modulo field equations).

The attack applies when:

$$
\alpha^r < p
$$

This gives the **minimum number of rounds** for security against interpolation:

$$
r_{\min} > \frac{\log p}{\log \alpha}
$$

### Partial round optimization

Poseidon uses a mix of **full rounds** (S-box on every element) and **partial
rounds** (S-box on one element). The degree growth in partial rounds is slower:
only one coordinate has its degree multiplied by $\alpha$ per round.

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: degree growth simulation
alpha = 5
full_rounds = 8
partial_rounds = 56
t = 3  # state width

# Full rounds: degree grows as alpha^r across all elements
# Partial rounds: degree grows as alpha^r for one element
degree_full = alpha^(full_rounds // 2)
degree_partial = alpha^partial_rounds
degree_after_second_full = degree_full * alpha^(full_rounds // 2)

total_degree = degree_full * degree_partial * degree_full
print(f"Upper bound on degree after all rounds: {total_degree}")
print(f"log2(degree): {float(log(total_degree, 2)):.1f}")
print(f"log2(p) for BN254: ~254")
`} />
<!-- prettier-ignore-end -->

## Invariant subspace attack

An **invariant subspace** $V \subseteq \mathbb{F}_p^t$ is a subspace (or coset)
that is mapped to itself (or another coset) by every round of the permutation.
If such a subspace exists, inputs from $V$ produce outputs in a predictable
subset, breaking the random permutation assumption.

AO hash functions must be designed so that the combination of S-box and MDS
matrix does not admit invariant subspaces. The round constants play a role in
breaking potential invariant structures.

## References

- Jakobsen, Knudsen. "The Interpolation Attack on Block Ciphers" (FSE 1997)
- Grassi et al. "Poseidon: A New Hash Function for Zero-Knowledge Proof Systems"
  (USENIX Security 2021), Section 5
