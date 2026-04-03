# SageMath: demonstrate the cost asymmetry of forward vs inverse S-box

p = 2^64 - 2^32 + 1  # Goldilocks
F = GF(p)
alpha = 7  # smallest alpha coprime to p-1 for Goldilocks (5 divides p-1)
alpha_inv = inverse_mod(alpha, p - 1)

print(f"Field: Goldilocks (p = 2^64 - 2^32 + 1)")
print(f"alpha = {alpha}")
print(f"alpha_inv = {alpha_inv}")
print(f"Bit length of alpha: {ZZ(alpha).nbits()}")
print(f"Bit length of alpha_inv: {ZZ(alpha_inv).nbits()}")
print()

# Count multiplications
fwd_bits = ZZ(alpha).digits(2)
inv_bits = ZZ(alpha_inv).digits(2)
fwd_muls = (len(fwd_bits) - 1) + (sum(fwd_bits) - 1)
inv_muls = (len(inv_bits) - 1) + (sum(inv_bits) - 1)

print(f"Forward x^{alpha}:")
print(f"  Binary: {ZZ(alpha).str(2)}")
print(f"  Multiplications: {fwd_muls}")
print()
print(f"Inverse x^(1/{alpha}):")
print(f"  Binary length: {len(inv_bits)} bits")
print(f"  Hamming weight: {sum(inv_bits)}")
print(f"  Multiplications: {inv_muls}")
print()
print(f"Ratio: inverse is {int(inv_muls / fwd_muls)}x more expensive on CPU")
print()

# Verify correctness
x = F(123456789)
y = x^alpha
z = y^alpha_inv
assert z == x
print(f"Verification: (x^{alpha})^(alpha_inv) == x? {z == x}")
