# SageMath: Groebner basis on a toy system
# (illustrative - real attacks use much larger fields)
p = 101
F = GF(p)
R = PolynomialRing(F, 'x,y,z', order='degrevlex')
x, y, z = R.gens()

# Toy 1-round system: S-box x^5, simple linear layer
alpha = 5
# Round: apply S-box then add constants
f1 = x^alpha + 2*y^alpha + 3*z^alpha - 42
f2 = 3*x^alpha + y^alpha + 2*z^alpha - 17
f3 = 2*x^alpha + 3*y^alpha + z^alpha - 89

I = R.ideal([f1, f2, f3])
print("Computing Groebner basis...")
G = I.groebner_basis()
print(f"Groebner basis has {len(G)} elements")
for g in G:
    print(f"  degree {g.degree()}: {g}")
