# SageMath: measure relative cost of field operations
# We count the number of field multiplications as the cost metric,
# since multiplication dominates on CPU.

def count_muls_power(alpha):
    """
    Count field multiplications for x^alpha via square-and-multiply.
    """
    if alpha <= 1:
        return 0
    bits = ZZ(alpha).digits(2)
    squarings = len(bits) - 1
    extra_muls = sum(bits) - 1
    return squarings + extra_muls

def count_muls_inverse_power(alpha, p):
    """
    Count field multiplications for x^(1/alpha) mod p.
    The inverse exponent is alpha_inv = inverse_mod(alpha, p-1),
    which is typically close to p in size.
    Returns None if alpha is not invertible mod p-1.
    """
    if gcd(alpha, p - 1) != 1:
        return None
    alpha_inv = inverse_mod(alpha, p - 1)
    bits = ZZ(alpha_inv).digits(2)
    squarings = len(bits) - 1
    extra_muls = sum(bits) - 1
    return squarings + extra_muls

# BN254 scalar field
p_bn254 = 21888242871839275222246405745257275088548364400416034343698204186575808495617
# Goldilocks
p_gold = 2^64 - 2^32 + 1

print("Field multiplication counts per S-box evaluation")
print("=" * 65)
print(f"{'alpha':>6} | {'x^alpha muls':>13} | {'x^(1/alpha) BN254':>18} | {'x^(1/alpha) Gold':>17}")
print("-" * 65)
for alpha in [3, 5, 7, 11]:
    fwd = count_muls_power(alpha)
    inv_bn = count_muls_inverse_power(alpha, p_bn254)
    inv_gold = count_muls_inverse_power(alpha, p_gold)
    inv_bn_str = str(inv_bn) if inv_bn is not None else "N/A (not coprime)"
    inv_gold_str = str(inv_gold) if inv_gold is not None else "N/A (not coprime)"
    print(f"{alpha:>6} | {fwd:>13} | {inv_bn_str:>18} | {inv_gold_str:>17}")

print()
print("Key observation: the inverse S-box is ~100x more expensive on CPU")
print("than the forward S-box. This is the main CPU disadvantage of Rescue.")
