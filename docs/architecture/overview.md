# Architecture Overview

## Project Introduction

The Adaptive Access-Aware Banked Register File is a low-power register file architecture designed for RISC-V processors. The primary objective is to reduce unnecessary clock activity by activating only the register banks involved in the current instruction.

Unlike a conventional register file, where the complete storage array receives the clock every cycle, this design divides the register file into multiple independent banks and selectively enables them according to runtime access patterns.

The current implementation serves as the baseline architecture for future enhancements such as fetch-stage awareness, adaptive threshold control, and predictive bank activation.

---

# Design Objectives

The objectives of this project are:

- Implement a synthesizable 32 × 32-bit RISC-V register file.
- Partition the register file into four independent banks.
- Monitor runtime read and write accesses.
- Dynamically enable only active register banks.
- Reduce unnecessary clock switching activity.
- Maintain functional compatibility with the RISC-V ISA.
- Provide a modular architecture suitable for future research extensions.

---

# Implemented Features

The current version (v1.0) includes:

- 32 General Purpose Registers
- Four-bank register file organization
- Dual asynchronous read ports
- Single synchronous write port
- Runtime bank access generation
- Access monitor with configurable timeout counter
- Bank-level clock gating
- x0 register protection
- Self-checking verification environment
- Clock activity statistics
- Bank access statistics

---

# High-Level Architecture

The design is composed of five RTL modules.

```
                 +----------------------+
                 |  CPU Read / Write    |
                 +----------+-----------+
                            |
                            |
                +-----------v-----------+
                | Bank Access Generator |
                +-----------+-----------+
                            |
                     Bank Access Vector
                            |
                +-----------v-----------+
                | Access Monitor        |
                | (Adaptive Counter)    |
                +-----------+-----------+
                            |
                     Bank Enable Signals
                            |
                +-----------v-----------+
                | Clock Gating Logic    |
                +-----------+-----------+
                            |
                    Gated Clock Signals
                            |
                +-----------v-----------+
                | 4-Bank Register File  |
                +-----------------------+
```

---

# Design Flow

The operation of the architecture follows these steps:

1. The processor issues read and write requests.
2. The Bank Access Generator determines which register banks are accessed.
3. The Access Monitor updates activity counters for the active banks.
4. Active banks remain enabled for a predefined timeout period.
5. The Clock Gating module generates gated clocks for enabled banks.
6. The Banked Register File performs read and write operations using the gated clocks.
7. Clock activity and bank statistics are collected for verification and performance analysis.

---

# Current Design Scope

The present implementation focuses on functional correctness and power-aware clock management.

The following advanced features are reserved for future versions:

- Fetch-stage awareness
- Adaptive threshold tuning
- Access prediction
- Dynamic power estimation
- FPGA implementation
- UVM-based verification

---

# Version Information

Current Version: **v1.0**

Status:

- RTL Completed
- Functional Verification Completed
- Clock Gating Implemented
- Documentation In Progress