# SageMath: demonstrate the inverse S-box advantage in AIR
# Both directions use the same constraint degree

p = 97
F = GF(p)
alpha = 5
alpha_inv = inverse_mod(alpha, p - 1)

x = F(42)

# Forward S-box: y = x^alpha
y = x^alpha
# AIR transition constraint: y - x^alpha == 0 (degree alpha)
assert y - x^alpha == 0
print(f"Forward S-box: y = x^{alpha}")
print(f"  x = {x}, y = {y}")
print(f"  Constraint: y - x^{alpha} = 0  (degree {alpha})")

print()

# Inverse S-box: z = x^(1/alpha) = x^alpha_inv
z = x^alpha_inv
# AIR transition constraint: x - z^alpha == 0 (degree alpha!)
assert x - z^alpha == 0
print(f"Inverse S-box: z = x^(1/{alpha})")
print(f"  x = {x}, z = {z}")
print(f"  Constraint: x - z^{alpha} = 0  (still degree {alpha}!)")

print()
print("Both directions use degree-{} constraints.".format(alpha))
print("Rescue gets 2x nonlinearity for the same AIR cost per round.")

# Compare total constraints: Rescue vs Poseidon
print()
print("Comparison for t=3:")
print(f"  Poseidon full round: {3} constraints of degree {alpha}")
print(f"  Rescue full round: {3}+{3} = {6} constraints of degree {alpha}")
print(f"  But Rescue needs ~14 rounds vs Poseidon's ~65")
print(f"  Rescue AIR total: ~{14 * 6} constraints")
print(f"  Poseidon AIR total: ~{8 * 3 + 57 * 1} constraints (full+partial)")
