---
sidebar_position: 2
---

# Poseidon2

## Overview

**Poseidon2** is a revised version of Poseidon with a more efficient linear
layer and updated round structure. It maintains the same S-box but uses
different matrix constructions for internal and external rounds.

- **Authors**: Grassi, Khovratovich, Maller, Rechberger, Schofnegger
- **Year**: 2023
- **S-box**: $x^{\alpha}$ (same as Poseidon)
- **Structure**: SPN with external rounds + internal rounds

## Key differences from Poseidon

1. **External rounds** replace full rounds with a new MDS matrix that is cheaper
   to compute (e.g., circulant or structured sparse)
2. **Internal rounds** replace partial rounds with a diagonal matrix plus a
   rank-1 update, reducing constraint cost
3. The linear layer in internal rounds is
   $M_I = \text{diag}(d_1, \ldots, d_t) + \mathbf{1}\mathbf{1}^T$

## Security timeline

### 2023 - Original paper

Introduces Poseidon2 with updated security analysis accounting for the new
linear layers. Claims equivalent security to Poseidon with fewer constraints.

### 2023-2024 - Third-party analyses

Ongoing analysis of whether the sparser internal linear layer weakens resistance
to Groebner basis attacks compared to full MDS.

## Sage code

Reference implementation: `sage/poseidon2/permutation.sage`

## References

- Grassi, Khovratovich, Maller, Rechberger, Schofnegger. "Poseidon2: A Faster
  Version of the Poseidon Hash Function" (2023)
  [ePrint 2023/323](https://eprint.iacr.org/2023/323)
