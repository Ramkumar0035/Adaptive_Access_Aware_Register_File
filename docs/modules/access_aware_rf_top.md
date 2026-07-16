# access_aware_rf_top

## Overview

`access_aware_rf_top` is the top-level module of the Adaptive Access-Aware Banked Register File. It integrates all RTL modules and provides the external interface between the processor and the adaptive register file architecture.

This module does not implement register storage or monitoring logic directly. Instead, it coordinates the interaction between the Bank Access Generator, Access Monitor, Clock Gating logic, and the Banked Register File.

---

# Purpose

The top module is responsible for:

- Receiving processor read requests
- Receiving processor write requests
- Determining active register banks
- Enabling required register banks
- Generating gated clocks
- Connecting all RTL modules together
- Returning register read data

---

# RTL Hierarchy

```
access_aware_rf_top

│

├── bank_access_generator

├── access_monitor_v2

├── clock_gating
│     ├── Clock Gate 0
│     ├── Clock Gate 1
│     ├── Clock Gate 2
│     └── Clock Gate 3

└── banked_rf
```

---

# Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| clk | 1 | System clock |
| rst | 1 | Active-high reset |
| we | 1 | Write enable |
| waddr | 5 | Write register address |
| wdata | 32 | Write data |
| read_valid1 | 1 | Read enable for Port 1 |
| read_valid2 | 1 | Read enable for Port 2 |
| raddr1 | 5 | Read address Port 1 |
| raddr2 | 5 | Read address Port 2 |

---

# Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| rdata1 | 32 | Read data from Port 1 |
| rdata2 | 32 | Read data from Port 2 |
| bank_access | 4 | Active bank vector |
| bank_enable | 4 | Enabled bank vector |

---

# Internal Signals

The module generates several internal signals used for communication between RTL blocks.

| Signal | Description |
|---------|-------------|
| r_bank1 | Read bank index for Port 1 |
| r_bank2 | Read bank index for Port 2 |
| w_bank | Write bank index |
| bank_clk0 | Gated clock for Bank0 |
| bank_clk1 | Gated clock for Bank1 |
| bank_clk2 | Gated clock for Bank2 |
| bank_clk3 | Gated clock for Bank3 |

---

# Module Connections

The top-level module connects the RTL blocks in the following order.

```
Processor Interface

↓

Bank Access Generator

↓

Access Monitor

↓

Clock Gating

↓

Banked Register File

↓

Read Data
```

---

# Functional Operation

The module performs the following sequence.

1. Receives processor read and write requests.
2. Decodes the accessed register banks.
3. Generates the bank access vector.
4. Updates activity counters.
5. Produces bank enable signals.
6. Generates gated clocks.
7. Performs register read and write operations.
8. Returns read data to the processor.

---

# Design Notes

- Fully synthesizable RTL
- Modular architecture
- Independent clock generation for each bank
- Supports future adaptive enhancements
- Maintains RISC-V x0 register behavior

---

# Dependencies

This module instantiates:

- bank_access_generator
- access_monitor_v2
- clock_gating (4 instances)
- banked_rf

---

# Verification Status

The module has been verified through a self-checking Verilog testbench covering:

- Read operations
- Write operations
- Multi-bank accesses
- Same-bank accesses
- Read-after-write
- Counter reload
- Clock gating
- x0 register protection

No functional errors were observed during directed simulation.

---

# Summary

The `access_aware_rf_top` module serves as the integration layer of the Adaptive Access-Aware Banked Register File. It coordinates all RTL components while presenting a clean interface to the processor and forms the foundation for future adaptive power-management features.