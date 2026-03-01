# SageMath Scripts

Executable SageMath scripts for AO hash function security analysis.

## Structure

```
sage/
├── poseidon/          # Poseidon reference implementation and attacks
├── poseidon2/         # Poseidon2 reference implementation
├── neptune/           # Neptune (Poseidon variant)
├── anemoi/            # Anemoi and Flystel construction
├── griffin/            # Griffin (Horst construction)
├── rescue/            # Rescue and Rescue-Prime
├── rescue_prime/      # Rescue-Prime specific
├── reinforced_concrete/  # Reinforced Concrete
├── tip5/              # Tip5
└── attacks/           # Generic attack implementations
```

## Running

```bash
sage <script>.sage
```

## Requirements

- SageMath >= 9.0
