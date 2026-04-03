# SageMath: AIR trace simulation for a Poseidon-like round
# Demonstrates how the execution trace looks for one full round

p = 101  # small prime for clarity
F = GF(p)
alpha = 5
t = 3  # state width

# MDS matrix (Cauchy construction)
xs = [F(i) for i in range(t)]
ys = [F(i + t) for i in range(t)]
M = matrix(F, t, t, lambda i, j: 1 / (xs[i] - ys[j]))

# Round constants (arbitrary for demonstration)
rc = [F(11), F(22), F(33)]

def poseidon_full_round(state, rc, M, alpha):
    """One full round: AddRC -> S-box -> MDS"""
    # AddRoundConstants
    state = [state[i] + rc[i] for i in range(len(state))]
    # S-box on all elements
    state = [x^alpha for x in state]
    # MDS
    v = vector(F, state)
    v = M * v
    return list(v)

# Initial state
state = [F(1), F(2), F(3)]
print("AIR trace for one Poseidon full round (t=3, alpha=5)")
print("=" * 50)
print(f"Row 0 (input):  {state}")

new_state = poseidon_full_round(state, rc, M, alpha)
print(f"Row 1 (output): {new_state}")

print()
print("Transition constraints (degree 5):")
# After adding round constants
state_rc = [state[i] + rc[i] for i in range(t)]
for j in range(t):
    sbox_out = state_rc[j]^alpha
    print(f"  col_{j}: verify S-box output = (input + rc)^{alpha}")

print()
print(f"Number of transition constraints: {t} (one per column)")
print(f"Constraint degree: {alpha}")
print(f"MDS is absorbed into the linear combination (free)")
