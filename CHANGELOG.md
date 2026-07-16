# Changelog

All notable changes to this project will be documented in this file.

The project follows a simple versioning scheme to track major milestones and feature additions.

---

## [v1.0.0] - Initial Stable Release

### Added

- 32 × 32-bit RISC-V register file
- Four-bank register organization
- Adaptive bank access monitoring
- Per-bank activity counters
- Independent clock gating
- Dual read ports
- Single write port
- Runtime bank access generation
- RISC-V compliant x0 register behavior

### Verification

- Directed self-checking Verilog testbench
- Golden reference model
- 17 functional test cases
- Assertion-based error checking
- Functional waveform validation
- Intel ModelSim simulation

### Documentation

- Architecture documentation
- RTL module documentation
- Verification methodology
- Test case documentation
- Waveform analysis
- Simulation results
- Performance analysis
- Limitations and future work

---

## Planned for Future Releases

### v1.1

- Fetch-stage-aware bank activation
- Improved adaptive policy
- Additional directed test cases

### v1.2

- FPGA implementation
- Resource utilization analysis
- Timing evaluation

### v2.0

- ASIC synthesis
- Power estimation
- Area analysis
- Integrated Clock Gating (ICG)
- Dynamic threshold adaptation