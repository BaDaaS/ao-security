import time

p = 101
F = GF(p)
alpha = 5
t = 2  # state width (small for tractability)

# MDS matrix
M = matrix(F, [[2, 1], [1, 3]])

def build_system(n_rounds):
    """Build polynomial system for n_rounds of a Poseidon-like permutation."""
    # Variables: input (layer 0) + intermediates (layers 1..n_rounds-1)
    n_vars = t * n_rounds  # intermediate + input vars (output is fixed)
    var_names = []
    for r in range(n_rounds):
        for j in range(t):
            var_names.append(f's{r}_{j}')
    R = PolynomialRing(F, var_names, order='degrevlex')
    vs = R.gens()

    # Group variables by round
    layers = []
    for r in range(n_rounds):
        layers.append([vs[r*t + j] for j in range(t)])

    # Fixed output (target)
    target = [F(42), F(17)]

    equations = []
    for r in range(1, n_rounds):
        # Round r: layers[r] = M * S-box(layers[r-1]) + constants
        sbox_out = [layers[r-1][j]^alpha for j in range(t)]
        for j in range(t):
            lhs = layers[r][j]
            rhs = sum(M[j,k] * sbox_out[k] for k in range(t)) + F(r*t + j + 1)
            equations.append(lhs - rhs)

    # Final round: target = M * S-box(layers[-1]) + constants
    sbox_out = [layers[-1][j]^alpha for j in range(t)]
    for j in range(t):
        rhs = sum(M[j,k] * sbox_out[k] for k in range(t)) + F(n_rounds*t + j + 1)
        equations.append(target[j] - rhs)

    return R, equations

for n_rounds in [2, 3, 4]:
    R, eqs = build_system(n_rounds)
    n_vars = len(R.gens())
    n_eqs = len(eqs)

    t0 = time.time()
    I = R.ideal(eqs)
    G = I.groebner_basis()
    elapsed = time.time() - t0

    print(f"Rounds: {n_rounds} | Vars: {n_vars} | Eqs: {n_eqs} | "
          f"GB size: {len(G)} | Max degree: {max(g.degree() for g in G)} | "
          f"Time: {elapsed:.3f}s")
