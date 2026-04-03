# SageMath: R1CS constraint count for x^alpha via square-and-multiply
# Each intermediate multiplication costs exactly one R1CS constraint.

def sbox_r1cs_chain(alpha):
    """
    Return the multiplication chain for x^alpha and count R1CS constraints.
    Uses binary method (square-and-multiply).
    """
    if alpha <= 1:
        return [], 0
    bits = ZZ(alpha).digits(2)  # LSB first
    steps = []
    # Start: we have x (cost 0)
    # Squarings give x^2, x^4, x^8, ...
    # We multiply in the bits that are set
    acc_exp = 1
    constraints = 0
    powers = {1: 'x'}
    current_sq = 1

    # Build addition chain from binary representation
    chain = []
    for i in range(len(bits) - 1):
        # Square
        new_exp = current_sq * 2
        chain.append(f"x^{new_exp} = x^{current_sq} * x^{current_sq}")
        constraints += 1
        current_sq = new_exp

    # Now multiply together the powers where bits are set
    result_exp = 0
    parts = []
    for i, b in enumerate(bits):
        if b == 1:
            parts.append(2^i)

    # Combine parts
    if len(parts) >= 2:
        acc = parts[0]
        for p in parts[1:]:
            chain.append(f"x^{acc + p} = x^{acc} * x^{p}")
            constraints += 1
            acc = acc + p

    return chain, constraints

print("R1CS constraint chains for common S-box exponents")
print("=" * 55)
for alpha in [3, 5, 7, 11, 13]:
    chain, cost = sbox_r1cs_chain(alpha)
    print(f"\\nalpha = {alpha}: {cost} constraints")
    for step in chain:
        print(f"  {step}")

print("\\n" + "=" * 55)
print("\\nFull Poseidon permutation R1CS cost (t=3, alpha=5)")
t = 3
R_F = 8
R_P = 57
_, sbox_cost = sbox_r1cs_chain(5)
full_round_constraints = t * sbox_cost  # all elements get S-box
partial_round_constraints = 1 * sbox_cost  # only first element
total = R_F * full_round_constraints + R_P * partial_round_constraints
print(f"  S-box cost per element: {sbox_cost} constraints")
print(f"  Full round ({t} S-boxes): {full_round_constraints} constraints")
print(f"  Partial round (1 S-box): {partial_round_constraints} constraints")
print(f"  Total: {R_F}*{full_round_constraints} + {R_P}*{partial_round_constraints} = {total} constraints")
print(f"  (MDS matrix is free in R1CS: linear operations cost 0)")
