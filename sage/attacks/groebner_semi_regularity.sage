# 1-round AO system over a small field
p = 101
F = GF(p)
R.<x, y, z> = PolynomialRing(F, order='degrevlex')
alpha = 5

# One round: S-box then linear mix then constants
# Output = M * S-box(input) + constants
# We set up equations: output is known, solve for input
f1 = x^alpha + 2*y^alpha + 3*z^alpha - 42
f2 = 3*x^alpha + y^alpha + 2*z^alpha - 17
f3 = 2*x^alpha + 3*y^alpha + z^alpha - 89

I = R.ideal([f1, f2, f3])
G = I.groebner_basis()

print(f"System: 3 equations of degree {alpha} in 3 variables over F_{p}")
print(f"Groebner basis has {len(G)} elements:\n")
for i, g in enumerate(G):
    print(f"  g{i+1} (degree {g.degree()}): {g}")

# The last element is univariate in z -> we can read off solutions
print(f"\nVariety (solutions):")
V = I.variety()
for sol in V:
    print(f"  x={sol[x]}, y={sol[y]}, z={sol[z]}")
