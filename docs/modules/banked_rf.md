# banked_rf

## Overview

The `banked_rf` module implements a 32 × 32-bit RISC-V register file using four independent register banks. Each bank stores eight registers and is driven by its own gated clock, allowing inactive banks to remain idle while active banks continue operating.

The register file supports one write port and two independent read ports.

---

# Purpose

The module is responsible for:

- Storing the architectural registers
- Dividing the register file into four banks
- Supporting dual-port reads
- Supporting single-port writes
- Preventing writes to x0
- Returning zero when x0 is read
- Operating each bank with an independent gated clock

---

# Register Organization

The 32 registers are divided into four banks.

| Bank | Register Range |
|------|----------------|
| Bank0 | x0 – x7 |
| Bank1 | x8 – x15 |
| Bank2 | x16 – x23 |
| Bank3 | x24 – x31 |

Each bank stores eight 32-bit registers.

---

# Address Mapping

Each register address consists of five bits.

```
[4:3] → Bank Number

[2:0] → Register Index
```

Example:

| Register | Address | Bank | Index |
|----------|---------|------|-------|
| x3 | 00011 | Bank0 | 3 |
| x10 | 01010 | Bank1 | 2 |
| x18 | 10010 | Bank2 | 2 |
| x29 | 11101 | Bank3 | 5 |

---

# Internal Memory Organization

The register file contains four memory arrays.

```verilog
bank0[7:0]

bank1[7:0]

bank2[7:0]

bank3[7:0]
```

Each location stores one 32-bit register.

---

# Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| bank_clk0 | 1 | Clock for Bank0 |
| bank_clk1 | 1 | Clock for Bank1 |
| bank_clk2 | 1 | Clock for Bank2 |
| bank_clk3 | 1 | Clock for Bank3 |
| we | 1 | Write enable |
| waddr | 5 | Write address |
| wdata | 32 | Write data |
| raddr1 | 5 | Read address port 1 |
| raddr2 | 5 | Read address port 2 |

---

# Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| rdata1 | 32 | Read data from port 1 |
| rdata2 | 32 | Read data from port 2 |

---

# Write Operation

The write address is decoded into:

- Target bank
- Register index

Only the selected bank receives a write operation.

Example:

```
Write x18

↓

Bank2

↓

Register 2

↓

bank2[2]
```

Each bank performs writes using its own gated clock.

---

# Read Operation

Two independent combinational read ports are implemented.

Both ports can access different banks simultaneously.

Example

```
Read Port1 → x3

Read Port2 → x29
```

Both values are returned in the same cycle.

---

# x0 Register Handling

The RISC-V ISA defines register x0 as a constant zero.

The design enforces this by:

- Ignoring writes to address 0
- Returning zero whenever x0 is read

This guarantees ISA compliance.

---

# Independent Clocking

Each bank is driven by an independent gated clock.

```
Bank0 ← bank_clk0

Bank1 ← bank_clk1

Bank2 ← bank_clk2

Bank3 ← bank_clk3
```

Only the accessed bank receives clock transitions.

---

# Advantages of Banking

The banked architecture provides:

- Reduced switching activity
- Independent bank operation
- Lower dynamic power
- Scalable organization
- Easier integration with clock gating

---

# Verification

The module has been verified for:

- Register initialization
- Single writes
- Single reads
- Dual reads
- Same-bank reads
- Cross-bank reads
- Read-after-write
- Write-only operation
- x0 protection
- Independent bank operation
- Clock-gated writes

All verification tests completed successfully.

---

# Design Characteristics

The implemented register file is:

- Four-bank architecture
- 32 registers
- 32-bit data width
- Dual read ports
- Single write port
- Independent gated clocks
- RISC-V compatible
- Synthesizable RTL

---

# Future Enhancements

Future versions may include:

- Multi-write support
- Error detection (ECC/parity)
- Dynamic bank resizing
- Adaptive threshold control
- Pipeline fetch-stage optimization

---

# Summary

The `banked_rf` module forms the storage core of the Adaptive Access-Aware Register File. By partitioning the register file into four independently clocked banks, it enables selective bank activation while maintaining full RISC-V functionality. Combined with the Access Monitor and Clock Gating modules, this organization reduces unnecessary switching activity and provides the foundation for an energy-aware register file architecture.