# SageMath: Cauchy MDS matrix
p = 101  # small prime for demonstration
F = GF(p)
t = 3
xs = [F(i) for i in range(t)]
ys = [F(i + t) for i in range(t)]
M = matrix(F, t, t, lambda i, j: 1 / (xs[i] - ys[j]))
print("Cauchy MDS matrix:")
print(M)
print(f"Determinant: {M.det()}")
# Verify all square submatrices are invertible
for size in range(1, t + 1):
    for rows in Combinations(range(t), size):
        for cols in Combinations(range(t), size):
            sub = M[rows, cols]
            assert sub.det() != 0, f"Singular submatrix at {rows}, {cols}"
print("All submatrices are invertible (MDS property verified)")
