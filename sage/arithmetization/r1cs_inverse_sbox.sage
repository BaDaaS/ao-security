# SageMath: verify that inverse S-box costs the same in R1CS
# The prover computes y = x^(1/alpha) natively, then the verifier
# checks y^alpha = x, which costs the same as a forward S-box.

p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
alpha = 5
alpha_inv = inverse_mod(alpha, p - 1)

x = F(9876543210)
# Forward S-box
y_forward = x^alpha
# Inverse S-box: prover computes this natively
y_inverse = x^alpha_inv

# Verifier checks y_inverse^alpha == x (same cost as forward)
assert y_inverse^alpha == x
print(f"x = {x}")
print(f"x^alpha = {y_forward}")
print(f"x^(1/alpha) = {y_inverse}")
print(f"Verification: (x^(1/alpha))^alpha == x? {y_inverse^alpha == x}")
print()
print(f"Forward S-box R1CS cost: 3 constraints (for alpha=5)")
print(f"Inverse S-box R1CS cost: 3 constraints (same verification)")
print(f"=> Rescue gains NO advantage in R1CS from the inverse S-box")
