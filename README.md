# Adaptive Access-Aware Register File for RISC-V

An RTL implementation of a banked RISC-V register file featuring adaptive bank activation and clock gating. The design monitors register bank accesses at runtime and enables only recently accessed banks, reducing unnecessary clock activity while maintaining correct functional behavior.

---

## Features

- 32 × 32-bit RISC-V register file
- Four-bank register organization
- Independent clock gating for each bank
- Adaptive access monitoring using per-bank counters
- Runtime bank access generation
- Dual read ports and single write port
- RISC-V compliant x0 register behavior
- Directed self-checking verification environment
- Intel ModelSim simulation support

---

## Repository Structure

```text
Adaptive_Access_Aware_Register_File/
│
├── docs/
│   ├── architecture/
│   ├── modules/
│   ├── verification/
│   ├── results/
│   └── research/
│
├── rtl/
│   ├── access_aware_rf_top.v
│   ├── access_monitor_v2.v
│   ├── bank_access_generator.v
│   ├── banked_rf.v
│   └── clock_gating.v
│
├── tb/
│   └── tb_access_aware_rf_top.v
│
├── tests/
│   ├── directed/
│   ├── regression/
│   └── reports/
│
├── waveforms/
│
├── images/
│
├── tools/
│
├── README.md
├── CHANGELOG.md
├── LICENSE
├── .gitignore
└── modelsim.do
```

---

## Architecture

The design consists of five primary RTL modules:

| Module | Description |
|--------|-------------|
| access_aware_rf_top | Top-level integration module |
| banked_rf | Four-bank RISC-V register file |
| bank_access_generator | Detects active register banks |
| access_monitor_v2 | Maintains adaptive bank activity counters |
| clock_gating | Generates independent gated clocks |

---

## Verification

The design was verified using a directed self-checking Verilog testbench in Intel ModelSim.

### Verification Summary

| Item | Result |
|------|--------|
| Test Cases | 17 |
| Passed | 17 |
| Failed | 0 |
| Functional Errors | 0 |

Verified features include:

- Register read/write
- Dual-port read operation
- Same-bank and cross-bank access
- Read-after-write
- Clock gating
- Adaptive counter operation
- Bank enable generation
- x0 register protection

---

## Simulation Results

Simulation confirmed:

- Correct register functionality
- Proper adaptive bank activation
- Independent clock gating
- Successful timeout and counter reload operation
- Correct bank access generation

Detailed simulation results are available in:

```
docs/results/
```

---

## Documentation

Project documentation is organized as follows:

| Folder | Contents |
|---------|----------|
| architecture | System-level design |
| modules | RTL module descriptions |
| verification | Verification methodology and test cases |
| results | Simulation analysis and observations |
| research | Future research material |

---

## Tools Used

- Verilog HDL
- Intel ModelSim
- Git
- GitHub

---

## Future Work

Planned enhancements include:

- FPGA implementation
- ASIC synthesis
- Integrated Clock Gating (ICG)
- Dynamic threshold adaptation
- Fetch-stage-aware bank prediction
- Power and timing analysis

---

## License

This project is released under the MIT License.

See the `LICENSE` file for details.