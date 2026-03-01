---
sidebar_position: 3
---

# Neptune

## Overview

**Neptune** is a variant of Poseidon developed by the Filecoin/Protocol Labs
ecosystem. It adapts Poseidon for use in Filecoin's proof-of- replication and
other storage proofs.

- **Authors**: Protocol Labs / Filecoin team
- **Year**: 2021
- **S-box**: $x^5$ (quintic)
- **Structure**: SPN, Poseidon-based with domain-specific parameter choices

## Differences from Poseidon

Neptune uses Poseidon's core design but with:

- Specific parameter sets optimized for Filecoin's BLS12-381 deployment
- Particular choices of MDS matrices and round constants
- Arity-specific optimizations for Merkle tree hashing (2-to-1, 4-to-1, 8-to-1)

## Security considerations

Neptune inherits Poseidon's security properties and is subject to the same
cryptanalytic results. The main security questions are whether the specific
parameter choices provide sufficient margin.

## References

- [Neptune specification](https://github.com/filecoin-project/neptune) (Filecoin
  documentation)
- Inherits from: Grassi et al. ["Poseidon"](https://eprint.iacr.org/2019/458)
  (2021)
