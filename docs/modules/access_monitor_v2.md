# access_monitor_v2

## Overview

The `access_monitor_v2` module monitors runtime register bank activity and determines which register banks should remain active. It receives the bank access vector from the Bank Access Generator, maintains an independent activity counter for each bank, and generates the bank enable signals used by the Clock Gating module.

This module forms the control logic responsible for activity-aware bank management.

---

# Purpose

The Access Monitor performs the following functions:

- Monitor runtime bank accesses
- Maintain independent activity counters
- Keep recently accessed banks active
- Disable inactive banks automatically
- Generate bank enable signals
- Provide the control input for bank-level clock gating

---

# Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| clk | 1 | System clock |
| rst | 1 | Active-high reset |
| bank_access | 4 | Active bank vector |

---

# Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| bank_enable | 4 | Clock enable vector for each bank |

---

# Internal Registers

The module maintains one activity counter for each bank.

| Counter | Associated Bank |
|----------|-----------------|
| counter0 | Bank0 |
| counter1 | Bank1 |
| counter2 | Bank2 |
| counter3 | Bank3 |

Each counter is initialized to zero after reset.

---

# Threshold

The counter reload value is controlled by a configurable parameter.

```verilog
parameter integer THRESHOLD = 4;
```

Whenever a bank is accessed,

```
Counter = THRESHOLD
```

The threshold can be modified without changing the RTL logic.

---

# Counter Operation

Each bank operates independently.

When a bank is accessed,

```
Access

↓

Counter = 4
```

During every clock cycle,

```
4

↓

3

↓

2

↓

1

↓

0
```

Once the counter reaches zero, the corresponding bank is considered inactive.

---

# Counter Reload

If another access occurs before the counter expires,

```
4

↓

3

↓

Access

↓

4
```

the counter is reloaded to the threshold value.

This allows frequently accessed banks to remain active.

---

# Bank Enable Generation

The bank enable signal is generated directly from the activity counters.

```
Counter > 0

↓

bank_enable = 1
```

```
Counter = 0

↓

bank_enable = 0
```

Thus, a bank remains enabled as long as its activity counter is non-zero.

---

# Example

Suppose the processor accesses register x18.

```
x18

↓

Bank2

↓

bank_access = 0100
```

The Access Monitor updates

```
counter2 = 4
```

The generated enable vector becomes

```
bank_enable = 0100
```

The Bank2 clock remains enabled while the counter counts down.

---

# Independent Bank Operation

Each bank maintains its own activity information.

Example

| Bank | Counter |
|------|---------|
| Bank0 | 0 |
| Bank1 | 3 |
| Bank2 | 1 |
| Bank3 | 4 |

Generated enable vector

```
1110
```

This allows different banks to become active and inactive independently.

---

# Reset Behavior

When reset is asserted,

```
counter0 = 0

counter1 = 0

counter2 = 0

counter3 = 0
```

Therefore,

```
bank_enable = 0000
```

No bank remains enabled after reset.

---

# Assertions

The module contains simple simulation-time assertions to verify that activity counters never exceed the configured threshold.

If an unexpected value is detected, an error message is generated during simulation.

These assertions improve debugging without affecting synthesis.

---

# Current Characteristics

The implemented Access Monitor provides:

- Runtime activity monitoring
- Independent bank counters
- Configurable timeout threshold
- Automatic counter reload
- Independent bank enable generation
- Simulation assertions

---

# Current Limitation

Although the project is called an Adaptive Access-Aware Register File, the current Access Monitor uses a fixed threshold.

The value

```
THRESHOLD = 4
```

does not change according to runtime behavior.

Therefore, the current implementation is better described as **activity-aware with a configurable timeout** rather than fully adaptive.

---

# Planned Enhancements

Future versions will extend the Access Monitor with:

- Dynamic threshold selection
- Access-frequency learning
- Instruction-aware bank activation
- Fetch-stage prediction
- Adaptive timeout control
- Runtime power optimization

These features will transform the current activity-aware monitor into a truly adaptive bank management system.

---

# Verification

The module has been verified for:

- Counter initialization
- Counter reload
- Counter decrement
- Timeout operation
- Independent bank operation
- Simultaneous multi-bank accesses
- Reset behavior
- Threshold assertions

Simulation confirmed correct bank enable generation under all directed test cases.

---

# Summary

The `access_monitor_v2` module is responsible for tracking register bank activity and generating the enable signals required for clock gating. By maintaining independent activity counters, it allows active banks to remain enabled while automatically disabling inactive banks after a configurable timeout period. This module forms the central control logic of the current activity-aware register file architecture and provides the foundation for future adaptive enhancements.