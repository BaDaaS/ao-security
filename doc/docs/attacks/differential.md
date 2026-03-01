---
sidebar_position: 3
---

# Differential Cryptanalysis

## Classical differential cryptanalysis

Differential cryptanalysis studies how **input differences** propagate through a
cipher. For an S-box $S$, the **differential probability** of an input
difference $\Delta_{\text{in}}$ mapping to an output difference
$\Delta_{\text{out}}$ is:

$$
\Pr[\Delta_{\text{in}} \to \Delta_{\text{out}}] = \frac{|\{x \in \mathbb{F}_p : S(x + \Delta_{\text{in}}) - S(x) = \Delta_{\text{out}}\}|}{p}
$$

## Power map differentials

For the power map $S(x) = x^{\alpha}$ over $\mathbb{F}_p$, the **differential
uniformity** is well studied:

- For $\alpha = 3$ (cube): differential uniformity is 2 (for most primes)
- For $\alpha = 5$: differential uniformity is 4
- For $\alpha = 7$: differential uniformity is 6

In general, for $\alpha$ odd:

$$
\delta(x^{\alpha}) \leq \alpha - 1
$$

The maximum differential probability per S-box is therefore $(\alpha - 1)/p$,
which is negligible for large $p$.

## Differential trails in AO hash functions

A **differential trail** over $r$ rounds specifies the input and output
differences at each round. The probability of the trail is the product of the
per-round probabilities.

For full rounds (S-box on every element), the MDS matrix ensures that active
S-boxes spread to all positions. The **branch number** $B$ of the MDS matrix
gives:

$$
\text{min active S-boxes over 2 rounds} \geq B = t + 1
$$

where $t$ is the state width. This gives a lower bound on the number of active
S-boxes over the full cipher.

### Partial round complication

In Poseidon's partial rounds, only one S-box is active per round. This means
differential trails through partial rounds can have fewer active S-boxes. The
security argument relies on the full rounds at the beginning and end providing
sufficient diffusion.

<!-- prettier-ignore-start -->
<SageCell code={`
# SageMath: differential uniformity of x^alpha
p = 101
F = GF(p)
alpha = 5

# Compute full DDT for small field
max_prob = 0
for delta_in in range(1, p):
    counts = {}
    for x in range(p):
        delta_out = F(F(x + delta_in)^alpha - F(x)^alpha)
        delta_out = int(delta_out)
        counts[delta_out] = counts.get(delta_out, 0) + 1
    local_max = max(counts.values())
    if local_max > max_prob:
        max_prob = local_max

print(f"Differential uniformity of x^{alpha} over F_{p}: {max_prob}")
print(f"Max differential probability: {max_prob}/{p} = {float(max_prob/p):.6f}")
`} />
<!-- prettier-ignore-end -->

## References

- Biham, Shamir. "Differential Cryptanalysis of DES-like Cryptosystems" (Journal
  of Cryptology, 1991)
- Grassi et al. "Poseidon" (2021), Section on differential analysis
