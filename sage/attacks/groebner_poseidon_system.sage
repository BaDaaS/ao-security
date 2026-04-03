# Illustrate the Macaulay matrix for a small system
p = 101
F = GF(p)
R.<x, y> = PolynomialRing(F, order='degrevlex')

# Simple system: two quadratic equations
f1 = x^2 + 3*x*y + 2*y^2 - 1
f2 = 2*x^2 + x*y + y^2 - 3

# Build Macaulay matrix at degree D=3
# Multiply each equation by all monomials up to degree D - deg(f_i)
D = 3
mons_D = R.monomials_of_degree(D) + R.monomials_of_degree(D-1) + R.monomials_of_degree(D-2) + R.monomials_of_degree(D-3)
# Get all monomials up to degree D, sorted by degrevlex
all_mons = sorted(set(mons_D), key=lambda m: (-m.degree(), str(m)))

# Multipliers for f1 (degree 2): multiply by monomials of degree <= 1
mult_f1 = [R(1), x, y]
# Multipliers for f2: same
mult_f2 = [R(1), x, y]

rows = []
for m in mult_f1:
    rows.append(m * f1)
for m in mult_f2:
    rows.append(m * f2)

# Build the matrix
M_mac = matrix(F, len(rows), len(all_mons))
for i, poly in enumerate(rows):
    for j, mon in enumerate(all_mons):
        M_mac[i, j] = poly.monomial_coefficient(mon)

print(f"Macaulay matrix at degree D={D}:")
print(f"  {M_mac.nrows()} rows (polynomial multiples)")
print(f"  {M_mac.ncols()} columns (monomials)")
print(f"  Rank: {M_mac.rank()}")
print(f"\nMonomials: {all_mons}")
print(f"\nMatrix:")
print(M_mac)

# Row-reduce to find the Groebner basis
print(f"\nRow echelon form:")
print(M_mac.echelon_form())
