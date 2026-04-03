# SageMath: degree growth experiment on small state
# Uses t=2 to keep memory usage manageable in CI.
p = 97
F = GF(p)
alpha = 5
t = 2  # state width (small to avoid memory explosion)

R = PolynomialRing(F, ['x%d' % i for i in range(t)])
xs = R.gens()

def sbox_full(state):
    return [x^alpha for x in state]

def sbox_partial(state):
    return [state[0]^alpha] + list(state[1:])

# Simple MDS: 2x2 matrix [[2,1],[1,2]]
def mds(state):
    return [
        2*state[0] + state[1],
        state[0] + 2*state[1],
    ]

def add_constants(state, r):
    return [s + F(r * t + i + 1) for i, s in enumerate(state)]

# Track degree through rounds
state = list(xs)
print("Round | Degree | Expected (alpha^r)")
print("------+--------+-------------------")
for r in range(4):
    # Full round
    state = sbox_full(state)
    state = mds(state)
    state = add_constants(state, r)
    max_deg = max(s.degree() for s in state)
    expected = alpha^(r + 1)
    print(f"  {r+1:3d} | {max_deg:>6} | {expected}")
