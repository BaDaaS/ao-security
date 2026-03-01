---
sidebar_position: 5
---

# Griffin

## Overview

**Griffin** uses a **Horst** construction that combines the power map
$x^{\alpha}$ with its inverse $x^{1/\alpha}$ in different branches of the state.
This creates an asymmetric structure where some branches are cheap to evaluate
forward and others backward.

- **Authors**: Grassi, Hao, Rechberger, Rot, Schofnegger, Walch
- **Year**: 2022
- **S-box**: $x^{\alpha}$ on some branches, $x^{1/\alpha}$ on others
- **Structure**: Horst (generalized Feistel-like with nonlinear feedback)

## Construction

The state is split into branches. In each round:

1. The first branch gets $x^{1/\alpha}$ (inverse S-box)
2. The second branch gets $x^{\alpha}$ (forward S-box)
3. The remaining branches are updated using nonlinear functions of the first two
   branches
4. A linear layer mixes all branches

The nonlinear feedback from the first two branches into the others is what gives
Griffin its name (a creature with different parts).

## Security considerations

The Horst structure is less studied than SPN. Key security questions:

- Does the feedback structure introduce exploitable algebraic relations?
- How does the degree grow compared to a pure SPN?
- What is the Groebner basis solving degree for the full system?

## Security timeline

### 2022 - Original paper

Introduces Griffin with initial security analysis.

### 2023 - Algebraic analysis

Follow-up work examining the Horst structure's algebraic properties more
carefully.

## References

- Grassi, Hao, Rechberger, Rot, Schofnegger, Walch. "Horst Meets Fluid- SPN:
  Griffin for Zero-Knowledge Applications" (2022)
  [ePrint 2022/403](https://eprint.iacr.org/2022/403)
