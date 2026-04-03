# SageMath: compare field sizes and their impact on arithmetic cost
# Larger fields need more limbs, making multiplication more expensive.

fields = [
    ("BabyBear", 2^31 - 2^27 + 1, 31),
    ("Goldilocks", 2^64 - 2^32 + 1, 64),
    ("BN254 scalar", 21888242871839275222246405745257275088548364400416034343698204186575808495617, 254),
    ("BLS12-381 scalar", 52435875175126190479447740508185965837690552500527637822603658699938581184513, 255),
]

print("Field size impact on CPU arithmetic cost")
print("=" * 70)
print(f"{'Field':>20} | {'Bits':>5} | {'64-bit limbs':>12} | {'Mul cost (relative)':>20}")
print("-" * 70)
for name, p, bits in fields:
    limbs = (bits + 63) // 64
    # Schoolbook multiplication: O(limbs^2)
    # Karatsuba: O(limbs^1.585)
    relative_cost = limbs^2
    print(f"{name:>20} | {bits:>5} | {limbs:>12} | {relative_cost:>20}")

print()
print("Observations:")
print("- BabyBear fits in a single 32-bit word: mul is 1 CPU multiply")
print("- Goldilocks fits in a single 64-bit word with fast reduction")
print("- BN254/BLS fields need 4 limbs: mul costs ~16x more than BabyBear")
print("- STARKs over small fields (BabyBear, Goldilocks) are much faster")
print("  on CPU, which is why modern STARK provers prefer them")
