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
