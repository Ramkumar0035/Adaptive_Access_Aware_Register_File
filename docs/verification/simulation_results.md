# Simulation Results

## Overview

The Adaptive Access-Aware Register File was functionally verified using a directed self-checking Verilog testbench in Intel ModelSim. The verification focused on validating register operations, adaptive bank activation, clock gating, and compliance with the RISC-V register file specification.

---

# Simulation Environment

| Item | Description |
|------|-------------|
| Simulator | Intel ModelSim |
| Language | Verilog HDL |
| Verification | Directed Self-Checking Testbench |
| Register File Size | 32 × 32-bit |
| Register Banks | 4 |
| Read Ports | 2 |
| Write Ports | 1 |

---

# Functional Verification Results

| Verification Item | Status |
|-------------------|--------|
| Register Initialization | ✅ Pass |
| Register Write | ✅ Pass |
| Register Read | ✅ Pass |
| Dual Read Operation | ✅ Pass |
| Same-Bank Read | ✅ Pass |
| Cross-Bank Read | ✅ Pass |
| Read After Write | ✅ Pass |
| x0 Register Protection | ✅ Pass |
| Bank Access Generation | ✅ Pass |
| Adaptive Counter Reload | ✅ Pass |
| Counter Decrement | ✅ Pass |
| Counter Expiry | ✅ Pass |
| Clock Gating | ✅ Pass |
| Multi-Bank Access | ✅ Pass |

---

# Verification Summary

| Metric | Value |
|--------|------:|
| Total Test Cases | 17 |
| Passed | 17 |
| Failed | 0 |
| Functional Errors | 0 |
| Register Mismatches | 0 |
| Counter Overflow | 0 |
| Bank Access Errors | 0 |

---

# Clock Activity

Clock gating reduced unnecessary clock propagation by enabling only banks that were recently accessed.

Example simulation statistics:

| Clock | Observed Pulses |
|--------|----------------:|
| Main Clock | 79 |
| Bank0 Clock | 15 |
| Bank1 Clock | 27 |
| Bank2 Clock | 34 |
| Bank3 Clock | 33 |

These values were obtained from the verification testbench and demonstrate that each bank receives clock transitions only when enabled by the adaptive access monitor.

---

# Bank Access Statistics

The access monitor recorded the following cumulative bank accesses during simulation.

| Bank | Access Count |
|------|-------------:|
| Bank0 | 3 |
| Bank1 | 9 |
| Bank2 | 7 |
| Bank3 | 11 |

These statistics indicate that bank activity varies according to the executed workload, demonstrating the adaptive behavior of the proposed architecture.

---

# Overall Result

The Adaptive Access-Aware Register File successfully completed all directed verification tests without functional failures. The simulation confirms correct operation of the banked register organization, adaptive access monitoring, independent clock gating, and RISC-V compliant register behavior.

---

# Conclusion

Simulation results demonstrate that the proposed architecture functions correctly under the evaluated workloads. The adaptive bank activation mechanism and independent clock gating operate as intended while preserving correct register file functionality.