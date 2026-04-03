# SageMath: 2-adicity and S-box exponent for each STARK-friendly field
fields = [
    ("Mersenne-31", 2^31 - 1),
    ("BabyBear",    2^31 - 2^27 + 1),
    ("KoalaBear",   2^31 - 2^24 + 1),
    ("Goldilocks",  2^64 - 2^32 + 1),
]

print("STARK-friendly fields: 2-adicity and smallest valid S-box exponent")
print("=" * 72)
print(f"{'Field':>12} | {'p':>22} | {'bits':>4} | {'2-adic':>6} | {'min alpha':>9}")
print("-" * 72)
for name, p in fields:
    assert is_prime(p), f"{name} is not prime!"
    bits = ZZ(p).nbits()
    # 2-adicity: largest k such that 2^k divides p-1
    two_adicity = valuation(p - 1, 2)
    # Smallest alpha >= 3 with gcd(alpha, p-1) = 1
    alpha = 3
    while gcd(alpha, p - 1) != 1:
        alpha += 2  # only odd candidates
    print(f"{name:>12} | {p:>22} | {bits:>4} | {two_adicity:>6} | {alpha:>9}")

print()
# Verify extension field irreducible polynomials
print("Extension field verification:")
R.<x> = GF(2^31 - 2^27 + 1)[]
assert (x^4 - 11).is_irreducible()
print("  BabyBear: x^4 - 11 is irreducible")

R2.<x> = GF(2^64 - 2^32 + 1)[]
assert (x^2 - 7).is_irreducible()
print("  Goldilocks: x^2 - 7 is irreducible")

R3.<x> = GF(2^31 - 1)[]
assert (x^3 - 5).is_irreducible()
print("  Mersenne-31: x^3 - 5 is irreducible")
