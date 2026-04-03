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
