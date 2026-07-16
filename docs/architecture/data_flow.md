# Data Flow

## Introduction

This document describes the operational flow of the Adaptive Access-Aware Banked Register File. It explains how processor requests propagate through the architecture, how active banks are identified, and how the register file performs read and write operations.

---

# Overall Data Flow

The complete data flow is illustrated below.

```
                Processor
                    │
                    │
      Read/Write Requests
                    │
                    ▼
      +-------------------------+
      | Bank Access Generator   |
      +-------------------------+
                    │
            bank_access[3:0]
                    │
                    ▼
      +-------------------------+
      | Access Monitor          |
      +-------------------------+
                    │
            bank_enable[3:0]
                    │
                    ▼
      +-------------------------+
      | Clock Gating            |
      +-------------------------+
                    │
      bank_clk0 ... bank_clk3
                    │
                    ▼
      +-------------------------+
      | Banked Register File    |
      +-------------------------+
                    │
              Read Data Output
```

---

# Read Operation

The read operation follows the sequence below.

### Step 1

The processor provides:

- Read Address 1
- Read Address 2
- Read Enable signals

---

### Step 2

The Bank Access Generator determines which register banks contain the requested registers.

Example

```
Read Address 1 = x10

↓

Bank1

Read Address 2 = x29

↓

Bank3

↓

bank_access = 1010
```

---

### Step 3

The Access Monitor reloads the counters of the active banks.

Example

```
Counter1 = 4

Counter3 = 4
```

Inactive banks continue counting down.

---

### Step 4

The Access Monitor generates

```
bank_enable
```

Example

```
bank_enable = 1010
```

---

### Step 5

The Clock Gating module enables only the required clocks.

```
Bank1 Clock

ON

Bank3 Clock

ON

Bank0 Clock

OFF

Bank2 Clock

OFF
```

---

### Step 6

The Banked Register File returns the requested register values.

```
Read Data 1

↓

x10

Read Data 2

↓

x29
```

---

# Write Operation

The write operation follows a similar sequence.

### Step 1

Processor provides

- Write Enable
- Write Address
- Write Data

---

### Step 2

The Bank Access Generator identifies the destination bank.

Example

```
Write Address = x18

↓

Bank2
```

---

### Step 3

The Access Monitor reloads the Bank2 activity counter.

```
Counter2 = Threshold
```

---

### Step 4

Bank2 clock remains enabled while the counter is non-zero.

---

### Step 5

The Banked Register File stores the data into the selected register.

```
Bank2

↓

Register x18

↓

Write Data
```

---

# Counter Operation

Each bank maintains an independent activity counter.

```
Access Detected

↓

Counter Reload

↓

4

↓

3

↓

2

↓

1

↓

0

↓

Clock Disabled
```

Whenever another access occurs before reaching zero, the counter is reloaded.

```
4

↓

3

↓

New Access

↓

4
```

---

# Clock Gating Flow

Clock generation follows the sequence below.

```
Main Clock

↓

Bank Enable

↓

Clock Gate

↓

Bank Clock

↓

Register Bank
```

Only active banks receive clock transitions.

---

# Example Transaction

Consider the following instruction sequence.

```
Read x10

Read x29

Write x18
```

The generated bank activity becomes

```
x10

↓

Bank1

x29

↓

Bank3

x18

↓

Bank2

↓

bank_access

1110
```

The enabled clocks are therefore

```
Bank0 OFF

Bank1 ON

Bank2 ON

Bank3 ON
```

---

# Summary

The data flow of the Adaptive Access-Aware Banked Register File consists of the following stages.

1. Processor generates requests.
2. Bank Access Generator identifies active banks.
3. Access Monitor updates activity counters.
4. Bank Enable signals are generated.
5. Clock Gating activates required bank clocks.
6. Banked Register File performs read and write operations.
7. Results are returned to the processor.

This organization minimizes unnecessary clock activity while maintaining correct register file functionality.