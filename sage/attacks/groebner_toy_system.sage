# Build and visualize a Macaulay matrix
p = 101
F = GF(p)
R.<x, y> = PolynomialRing(F, order='degrevlex')

# Two quadratic polynomials
f1 = x^2 + 3*x*y + 2*y^2 - 1
f2 = 2*x^2 + x*y + y^2 - 3

print(f"f1 = {f1}")
print(f"f2 = {f2}")

# Build Macaulay matrix at degree D=2 (no extension needed)
# At degree 2, we just use f1 and f2 directly
D = 2
# All monomials up to degree D
mons = [x^2, x*y, y^2, x, y, R(1)]
print(f"\nDegree-{D} Macaulay matrix")
print(f"Monomials: {mons}")

rows_polys = [f1, f2]
M2 = matrix(F, len(rows_polys), len(mons))
for i, poly in enumerate(rows_polys):
    for j, mon in enumerate(mons):
        M2[i, j] = poly.monomial_coefficient(mon)
print(f"\nM_2 ({M2.nrows()} x {M2.ncols()}):")
print(M2)

# Now extend to degree D=3: multiply each f_i by {1, x, y}
D = 3
mons3 = [x^3, x^2*y, x*y^2, y^3, x^2, x*y, y^2, x, y, R(1)]
multipliers = [R(1), x, y]

rows_polys3 = []
row_labels = []
for f, name in [(f1, 'f1'), (f2, 'f2')]:
    for m in multipliers:
        rows_polys3.append(m * f)
        row_labels.append(f"{m}*{name}")

M3 = matrix(F, len(rows_polys3), len(mons3))
for i, poly in enumerate(rows_polys3):
    for j, mon in enumerate(mons3):
        M3[i, j] = poly.monomial_coefficient(mon)

print(f"\nDegree-{D} Macaulay matrix")
print(f"Monomials: {mons3}")
print(f"Row labels: {row_labels}")
print(f"\nM_3 ({M3.nrows()} x {M3.ncols()}):")
print(M3)
print(f"Rank: {M3.rank()}")
print(f"\nRow echelon form:")
print(M3.echelon_form())
