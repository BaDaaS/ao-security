# SageMath: degree growth simulation
alpha = 5
full_rounds = 8
partial_rounds = 56
t = 3  # state width

# Full rounds: degree grows as alpha^r across all elements
# Partial rounds: degree grows as alpha^r for one element
degree_full = alpha^(full_rounds // 2)
degree_partial = alpha^partial_rounds
degree_after_second_full = degree_full * alpha^(full_rounds // 2)

total_degree = degree_full * degree_partial * degree_full
print(f"Upper bound on degree after all rounds: {total_degree}")
print(f"log2(degree): {float(log(total_degree, 2)):.1f}")
print(f"log2(p) for BN254: ~254")
