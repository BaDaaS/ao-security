# Compute Hilbert series for a polynomial ideal
p = 101
F = GF(p)
R.<x, y, z> = PolynomialRing(F, order='degrevlex')

# System of 3 quadratic equations in 3 variables
f1 = x^2 + 2*y*z + 3
f2 = y^2 + x*z + 7
f3 = z^2 + x*y + 11

I = R.ideal([f1, f2, f3])

# Compute Groebner basis first
G = I.groebner_basis()
print(f"Groebner basis has {len(G)} elements")
print(f"Max degree in GB: {max(g.degree() for g in G)}")

# Hilbert series of the quotient ring R/I
# For zero-dimensional ideals, this is a polynomial (finite sum)
HS = R.quotient(I).hilbert_series()
print(f"\nHilbert series of R/I:")
print(f"  HS(z) = {HS}")

# The number of solutions equals HS(1)
print(f"\nHS(1) = {HS(1)} (number of solutions, counting multiplicity)")

# Predicted Hilbert series under regularity assumption
# For 3 equations of degree 2 in 3 variables:
# HS(z) = (1-z^2)^3 / (1-z)^3 = (1+z)^3 = 1 + 3z + 3z^2 + z^3
S.<z> = PowerSeriesRing(QQ, default_prec=10)
HS_predicted = prod(1 - z^2 for _ in range(3)) / (1 - z)^3
print(f"\nPredicted HS (regular assumption):")
print(f"  {HS_predicted}")
print(f"  First non-positive coeff at degree: ", end="")
for d, c in enumerate(HS_predicted.list()):
    if c <= 0:
        print(f"{d} (solving degree)")
        break
