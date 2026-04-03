# SageMath: basic field arithmetic
p = 21888242871839275222246405745257275088548364400416034343698204186575808495617
F = GF(p)
a = F(42)
b = F(17)
print(f"a + b = {a + b}")
print(f"a * b = {a * b}")
print(f"a^(-1) = {a^(-1)}")
