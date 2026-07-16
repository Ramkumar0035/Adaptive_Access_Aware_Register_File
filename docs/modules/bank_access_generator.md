# bank_access_generator

## Overview

The `bank_access_generator` module determines which register banks are accessed during the current processor operation. It examines the read and write addresses together with their corresponding valid signals and generates a 4-bit bank access vector.

This module is purely combinational and does not contain any storage elements.

---

# Purpose

The primary responsibilities of this module are:

- Identify active register banks.
- Support simultaneous read and write operations.
- Ignore accesses to register x0.
- Generate a bank access vector for the Access Monitor.

---

# Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| raddr1 | 5 | Read address for Port 1 |
| raddr2 | 5 | Read address for Port 2 |
| waddr | 5 | Write address |
| r_bank1 | 2 | Decoded bank of Read Port 1 |
| r_bank2 | 2 | Decoded bank of Read Port 2 |
| w_bank | 2 | Decoded write bank |
| read_valid1 | 1 | Read Port 1 enable |
| read_valid2 | 1 | Read Port 2 enable |
| write_valid | 1 | Write enable |

---

# Output

| Signal | Width | Description |
|---------|------:|-------------|
| bank_access | 4 | Active bank vector |

---

# Bank Mapping

The register file is divided into four banks.

| Bank | Registers |
|------|-----------|
| Bank0 | x0 – x7 |
| Bank1 | x8 – x15 |
| Bank2 | x16 – x23 |
| Bank3 | x24 – x31 |

Each bit of the bank access vector represents one bank.

| Bit | Bank |
|----:|------|
| bank_access[0] | Bank0 |
| bank_access[1] | Bank1 |
| bank_access[2] | Bank2 |
| bank_access[3] | Bank3 |

---

# Functional Operation

The module performs three independent checks.

### Read Port 1

If Read Port 1 is valid and the address is not x0, the corresponding bank bit is asserted.

Example:

```
raddr1 = x10

↓

Bank1

↓

bank_access = 0010
```

---

### Read Port 2

If Read Port 2 is valid, its bank is also marked as active.

Example:

```
raddr2 = x29

↓

Bank3

↓

bank_access = 1000
```

---

### Write Port

When a valid write request occurs, the destination bank is also activated.

Example:

```
waddr = x18

↓

Bank2

↓

bank_access = 0100
```

---

# Multiple Bank Access

The module supports simultaneous accesses.

Example:

```
Read x10

↓

Bank1

Read x18

↓

Bank2

Write x29

↓

Bank3
```

Generated output:

```
bank_access = 1110
```

This allows multiple banks to remain active during the same processor cycle.

---

# x0 Handling

Register x0 is ignored by the Bank Access Generator.

Example:

```
Read x0

↓

Ignored

↓

No bank activated
```

This matches the RISC-V specification, where register x0 is permanently zero.

---

# Design Characteristics

- Pure combinational logic
- No clock required
- No internal registers
- Synthesizable Verilog RTL
- Supports simultaneous accesses
- Compatible with future adaptive extensions

---

# Verification

The module has been verified for:

- Single read
- Dual read
- Write only
- Read + Write
- Same-bank access
- Multi-bank access
- x0 access
- Invalid access

Simulation results confirmed correct generation of the bank access vector for all directed test cases.

---

# Summary

The `bank_access_generator` module is responsible for detecting the active register banks during each processor operation. It provides the bank access information required by the Access Monitor, enabling the adaptive clock-gating mechanism implemented in the overall architecture.