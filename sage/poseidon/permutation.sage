# Poseidon permutation reference implementation
# See: https://eprint.iacr.org/2019/458
#
# This is a minimal reference implementation for educational purposes.
# It implements the core Poseidon permutation over a prime field.

def poseidon_permutation(state, MDS, round_constants, alpha, R_F, R_P):
    """
    Poseidon permutation.

    Parameters:
        state: list of field elements (length t)
        MDS: t x t MDS matrix over the field
        round_constants: list of t-element lists, one per round
        alpha: S-box exponent
        R_F: number of full rounds
        R_P: number of partial rounds
    """
    t = len(state)
    F = state[0].parent()
    round_idx = 0

    # First half of full rounds
    for r in range(R_F // 2):
        # AddRoundConstants
        state = [state[i] + round_constants[round_idx][i] for i in range(t)]
        # S-box (full)
        state = [x^alpha for x in state]
        # MDS
        state = list(MDS * vector(state))
        round_idx += 1

    # Partial rounds
    for r in range(R_P):
        # AddRoundConstants
        state = [state[i] + round_constants[round_idx][i] for i in range(t)]
        # S-box (partial: only first element)
        state[0] = state[0]^alpha
        # MDS
        state = list(MDS * vector(state))
        round_idx += 1

    # Second half of full rounds
    for r in range(R_F // 2):
        # AddRoundConstants
        state = [state[i] + round_constants[round_idx][i] for i in range(t)]
        # S-box (full)
        state = [x^alpha for x in state]
        # MDS
        state = list(MDS * vector(state))
        round_idx += 1

    return state


# --- Example usage with a small field ---
if __name__ == "__main__":
    p = 101  # small prime for demonstration
    F = GF(p)
    t = 3
    alpha = 5
    R_F = 8
    R_P = 14

    assert gcd(alpha, p - 1) == 1, "alpha must be coprime to p-1"

    # Simple Cauchy MDS matrix
    xs = [F(i) for i in range(t)]
    ys = [F(i + t) for i in range(t)]
    MDS = matrix(F, t, t, lambda i, j: 1 / (xs[i] - ys[j]))

    # Generate round constants (deterministic, not cryptographically secure)
    total_rounds = R_F + R_P
    round_constants = []
    for r in range(total_rounds):
        rc = [F(r * t + i + 1) for i in range(t)]
        round_constants.append(rc)

    # Test permutation
    input_state = [F(1), F(2), F(3)]
    output_state = poseidon_permutation(
        input_state, MDS, round_constants, alpha, R_F, R_P
    )
    print(f"Input:  {input_state}")
    print(f"Output: {output_state}")
