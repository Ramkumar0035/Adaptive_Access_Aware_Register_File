# clock_gating

## Overview

The `clock_gating` module generates a gated clock for each register bank. It receives the system clock and a bank enable signal from the Access Monitor. When the enable signal is asserted, the system clock is forwarded to the corresponding register bank. Otherwise, the clock is blocked.

One instance of this module is used for each register bank, resulting in four independent gated clocks.

---

# Purpose

The module performs the following functions:

- Receive the system clock
- Receive the bank enable signal
- Generate a gated clock
- Prevent unnecessary clock activity in inactive banks

---

# Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| clk | 1 | System clock |
| enable | 1 | Bank enable signal |

---

# Output

| Signal | Width | Description |
|---------|------:|-------------|
| gated_clk | 1 | Clock supplied to the register bank |

---

# RTL Logic

The current implementation uses simple combinational clock gating.

```verilog
assign gated_clk = clk & enable;
```

When

```
enable = 1
```

```
gated_clk = clk
```

When

```
enable = 0
```

```
gated_clk = 0
```

---

# Operation

The Clock Gating module behaves as shown below.

| Enable | Clock | Gated Clock |
|--------:|------:|------------:|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

If the enable signal remains low, the register bank does not receive clock transitions.

---

# Example

Suppose

```
bank_enable = 0100
```

The generated clocks become

| Clock | Status |
|--------|--------|
| Bank0 Clock | OFF |
| Bank1 Clock | OFF |
| Bank2 Clock | ON |
| Bank3 Clock | OFF |

Only Bank2 receives the system clock.

---

# Multiple Clock Gates

The top-level module instantiates four copies of this module.

```
Main Clock

↓

Clock Gate 0

↓

Bank0 Clock

---------------------

Main Clock

↓

Clock Gate 1

↓

Bank1 Clock

---------------------

Main Clock

↓

Clock Gate 2

↓

Bank2 Clock

---------------------

Main Clock

↓

Clock Gate 3

↓

Bank3 Clock
```

Each clock gate operates independently.

---

# Design Characteristics

The implemented clock gate is:

- Simple
- Synthesizable
- Easy to understand
- Suitable for functional verification

---

# Current Limitation

The current RTL uses a combinational AND gate for clock gating.

Although this is sufficient for RTL simulation and functional verification, ASIC implementations typically use dedicated Integrated Clock Gating (ICG) cells to eliminate glitches and improve clock-tree quality.

For FPGA implementations, synthesis tools may also replace this logic with clock-enable resources depending on the target device and synthesis settings.

---

# Future Enhancements

Future versions may include:

- Integrated Clock Gating (ICG) cells
- Glitch-free clock gating
- Technology-specific clock gating
- Automatic synthesis constraints
- ASIC-ready implementation

---

# Verification

The module has been verified for:

- Enable = 0
- Enable = 1
- Clock propagation
- Independent bank operation
- Integration with the Access Monitor

Simulation confirmed that gated clocks are generated only for enabled register banks.

---

# Summary

The `clock_gating` module provides independent gated clocks for each register bank. It serves as the interface between the Access Monitor and the Banked Register File, reducing unnecessary clock activity by supplying clock transitions only to active banks. While the current implementation uses a simple RTL gate suitable for functional verification, future versions can adopt technology-specific clock-gating cells for ASIC or FPGA optimization.