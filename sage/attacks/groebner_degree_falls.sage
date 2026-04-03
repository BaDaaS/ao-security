# S-polynomial computation
p = 101
F = GF(p)
R.<x, y, z> = PolynomialRing(F, order='degrevlex')

f = 2*x^3*y + 3*x*y^2 + 5
g = x^2*y^2 + 4*y^3 + 1

print(f"f = {f}")
print(f"g = {g}")
print(f"LM(f) = {f.lm()}")
print(f"LM(g) = {g.lm()}")

# Compute S-polynomial manually
L = lcm(f.lm(), g.lm())
print(f"lcm(LM(f), LM(g)) = {L}")

S_fg = (L // f.lt()) * f - (L // g.lt()) * g
print(f"\nS(f, g) = {S_fg}")
print(f"Degree of S(f,g): {S_fg.degree()}")
print(f"(Leading terms cancelled: degree dropped from {L.degree()})")

# Verify with Sage's built-in
# Compute Groebner basis of {f, g} to see S-polynomial reduction in action
I = R.ideal([f, g])
G = I.groebner_basis()
print(f"\nGroebner basis of <f, g>:")
for i, gi in enumerate(G):
    print(f"  g{i+1}: {gi}")
