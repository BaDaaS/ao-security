# Groebner basis complexity estimation for AO hash functions
#
# Estimates the solving degree and complexity of Groebner basis
# attacks under the semi-regularity assumption.

def hilbert_series_coeffs(degrees, n_vars, max_degree):
    """
    Compute coefficients of the Hilbert series for a system of
    polynomials with given degrees in n_vars variables.

    H(z) = prod(1 - z^d_i) / (1 - z)^n

    Returns list of coefficients up to max_degree.
    """
    R = PowerSeriesRing(QQ, 'z', default_prec=max_degree + 1)
    z = R.gen()

    numerator = prod(1 - z^d for d in degrees)
    denominator = (1 - z)^n_vars

    H = numerator / denominator
    return list(H)[:max_degree + 1]


def estimated_solving_degree(degrees, n_vars, max_degree=200):
    """
    Estimate the solving degree from the Hilbert series.

    The solving degree is the index of the first non-positive
    coefficient in the Hilbert series.
    """
    coeffs = hilbert_series_coeffs(degrees, n_vars, max_degree)
    for i, c in enumerate(coeffs):
        if c <= 0:
            return i
    return max_degree  # did not find within range


def groebner_complexity(n_vars, solving_deg, omega=2.37):
    """
    Estimate Groebner basis computation complexity.

    Complexity is O(binomial(n + D, D)^omega) where n is the number
    of variables and D is the solving degree.
    """
    return binomial(n_vars + solving_deg, solving_deg)^omega


# --- Example: estimate for a Poseidon-like system ---
if __name__ == "__main__":
    # Poseidon with t=3, alpha=5
    # After unrolling, we get equations of degree 5 per round
    t = 3
    alpha = 5

    # For r rounds, we introduce t intermediate variables per round
    # and get t equations of degree alpha per round
    for n_rounds in range(1, 10):
        n_vars = t + t * n_rounds  # input + intermediates
        n_eqs = t * n_rounds  # equations from each round
        degrees = [alpha] * n_eqs

        D = estimated_solving_degree(degrees, n_vars)
        C = groebner_complexity(n_vars, D)

        print(f"Rounds: {n_rounds:2d} | "
              f"Vars: {n_vars:3d} | "
              f"Eqs: {n_eqs:3d} | "
              f"Solving degree: {D:3d} | "
              f"log2(complexity): {float(log(C, 2)):.1f}")
