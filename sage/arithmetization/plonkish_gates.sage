# SageMath: PlonK-ish gate simulation
# Demonstrate how a degree-5 custom gate encodes x^5 in one row

p = 101
F = GF(p)

# A PlonK-ish row has advice columns (witness) and selector columns (fixed).
# Custom gate: s_sbox * (w0^5 - w1) = 0

def verify_sbox_gate(w0, w1, selector):
    """Check the custom gate constraint."""
    return selector * (w0^5 - w1) == 0

# Active row (selector = 1): S-box gate
x = F(7)
y = x^5
print("PlonK-ish S-box gate (degree 5)")
print("=" * 45)
print(f"Gate equation: s_sbox * (w0^5 - w1) = 0")
print(f"  w0 = {x}, w1 = {y}, selector = 1")
print(f"  Constraint satisfied? {verify_sbox_gate(x, y, F(1))}")
print(f"  Cost: 1 row (vs 3 R1CS constraints)")

print()

# Inactive row (selector = 0): gate does not apply
print(f"Inactive row: selector = 0")
print(f"  w0 = {F(99)}, w1 = {F(0)}, selector = 0")
print(f"  Constraint satisfied? {verify_sbox_gate(F(99), F(0), F(0))}")

print()
print("Full Poseidon round in PlonK-ish (t=3, alpha=5):")
print("  Option A: 3 rows with degree-5 S-box gate each")
print("  Option B: 1 wide row combining S-box + MDS")
print()

# Simulate option A: separate rows
state = [F(1), F(2), F(3)]
print("Option A trace (3 rows per full round):")
for i, x in enumerate(state):
    y = x^5
    print(f"  Row {i}: w0={x}, w1={y}")
    assert verify_sbox_gate(x, y, F(1))

# Compare cost across full permutation
t = 3
R_F = 8
R_P = 57
option_a_rows = R_F * t + R_P * 1  # full rounds: t rows, partial: 1 row
print(f"\\nTotal rows (option A): {R_F}*{t} + {R_P}*1 = {option_a_rows}")
print(f"Compare to R1CS: {R_F * t * 3 + R_P * 1 * 3} constraints")
