# Anemoi Flystel construction reference implementation
# See: https://eprint.iacr.org/2022/840
#
# Implements the open Flystel S-box used in Anemoi.

def open_flystel(x, y, alpha, beta, gamma, delta, F):
    """
    Open Flystel construction.

    Parameters:
        x, y: input pair in F
        alpha: S-box exponent (must satisfy gcd(alpha, p-1) = 1)
        beta, gamma, delta: Flystel parameters in F
        F: the finite field
    """
    alpha_inv = inverse_mod(int(alpha), int(F.characteristic()) - 1)

    # Quadratic function
    def Q(t):
        return t^2 + beta * t

    # Forward evaluation
    v = x - Q(y)
    e = F(v)^alpha_inv  # "expensive" direction
    u = y - e

    # Output
    x_out = v + gamma
    y_out = u + delta

    return x_out, y_out


# --- Example usage ---
if __name__ == "__main__":
    p = 97
    F = GF(p)
    alpha = 5

    assert gcd(alpha, p - 1) == 1

    # Flystel parameters
    beta = F(3)
    gamma = F(7)
    delta = F(11)

    # Test
    x, y = F(42), F(17)
    x_out, y_out = open_flystel(x, y, alpha, beta, gamma, delta, F)
    print(f"Input:  ({x}, {y})")
    print(f"Output: ({x_out}, {y_out})")
