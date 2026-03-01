---
sidebar_position: 0
---

# Attack Techniques

This section covers the cryptanalytic techniques relevant to
arithmetization-oriented hash functions. Each technique is presented with:

1. The underlying theory
2. How it applies to AO constructions specifically
3. Executable SageMath code demonstrating the attack on reduced-round variants

## Overview

| Technique                                       | Targets                                  | Key metric                          |
| ----------------------------------------------- | ---------------------------------------- | ----------------------------------- |
| [Algebraic attacks](/attacks/algebraic-attacks) | Low-degree S-boxes                       | Polynomial degree, \#monomials      |
| [Groebner basis](/attacks/groebner-basis)       | Equation systems from full permutation   | Solving degree, regularity          |
| [Differential](/attacks/differential)           | S-boxes with low differential uniformity | Max differential probability        |
| [Algebraic degree](/attacks/algebraic-degree)   | Slow degree growth                       | Higher-order differential vanishing |
| [Statistical](/attacks/statistical)             | Linear/integral properties               | Bias, balanced property             |

## General principle

Classical symmetric cryptanalysis (DES, AES) focuses on **bit-level patterns**:
differential trails through S-box tables, linear approximations of Boolean
functions.

For AO hash functions, the S-boxes are **algebraic maps** over $\mathbb{F}_p$
(typically $x \mapsto x^{\alpha}$). This means:

- The nonlinear component has a compact algebraic description
- Attacks can leverage the **polynomial structure** directly
- Groebner basis and resultant computations become the primary tool
- The number of rounds needed for security is determined by **algebraic degree
  growth**, not diffusion metrics alone
