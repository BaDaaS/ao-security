# SageMath: degree growth experiment on small state
p = 101
F = GF(p)
alpha = 5
t = 3  # state width

R = PolynomialRing(F, ['x%d' % i for i in range(t)])
xs = R.gens()

def sbox_full(state):
    return [x^alpha for x in state]

def sbox_partial(state):
    return [state[0]^alpha] + list(state[1:])

# Simple MDS: circulant matrix [2, 1, 1]
def mds(state):
    return [
        2*state[0] + state[1] + state[2],
        state[0] + 2*state[1] + state[2],
        state[0] + state[1] + 2*state[2],
    ]

def add_constants(state, r):
    return [s + F(r * t + i + 1) for i, s in enumerate(state)]

# Track degree through rounds
state = list(xs)
print("Round | Degree")
print("------+-------")
for r in range(6):
    # Full round
    state = sbox_full(state)
    state = mds(state)
    state = add_constants(state, r)
    max_deg = max(s.degree() for s in state)
    print(f"  {r+1:3d} | {max_deg}")
