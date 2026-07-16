# Design Architecture

## Introduction

The Adaptive Access-Aware Banked Register File is organized as a collection of modular RTL blocks, where each module performs a dedicated function. This modular architecture improves readability, verification, maintenance, and future scalability.

Instead of embedding all functionality into a single RTL module, the design separates access detection, access monitoring, clock gating, and register storage into independent components.

---

# Top-Level Architecture

The complete architecture consists of five RTL modules.

```
                    +---------------------------+
                    |   Processor Interface     |
                    |---------------------------|
                    | Read Address 1            |
                    | Read Address 2            |
                    | Write Address             |
                    | Write Data                |
                    | Read Enables              |
                    | Write Enable              |
                    +-------------+-------------+
                                  |
                                  v
                  +-------------------------------+
                  | Bank Access Generator          |
                  +-------------------------------+
                                  |
                           bank_access[3:0]
                                  |
                                  v
                  +-------------------------------+
                  | Access Monitor                |
                  | Activity Counters             |
                  +-------------------------------+
                                  |
                           bank_enable[3:0]
                                  |
                                  v
                  +-------------------------------+
                  | Clock Gating                  |
                  +-------------------------------+
                                  |
                     bank_clk0 ... bank_clk3
                                  |
                                  v
                  +-------------------------------+
                  | Four-Bank Register File       |
                  +-------------------------------+
                                  |
                                  v
                           Read Data Outputs
```

---

# RTL Module Organization

The design is divided into the following RTL modules.

| Module | Function |
|---------|----------|
| access_aware_rf_top | Top-level integration of all RTL blocks |
| bank_access_generator | Identifies active banks from current read and write requests |
| access_monitor_v2 | Maintains activity counters and bank enable signals |
| clock_gating | Generates individual gated clocks for each register bank |
| banked_rf | Implements the four-bank register file |

---

# Module Interaction

The modules communicate using simple control signals.

Processor Requests

↓

Bank Access Generator

↓

Bank Access Vector

↓

Access Monitor

↓

Bank Enable Signals

↓

Clock Gating

↓

Banked Register File

↓

Read Data

---

# Register File Organization

The register file contains thirty-two 32-bit registers.

The storage is divided into four independent banks.

| Bank | Registers |
|------|-----------|
| Bank0 | x0 – x7 |
| Bank1 | x8 – x15 |
| Bank2 | x16 – x23 |
| Bank3 | x24 – x31 |

Each bank stores eight registers.

This organization allows clock activity to be limited only to the banks participating in the current operation.

---

# Clock Distribution

Instead of using a single clock for the complete register file, the design generates four independent bank clocks.

```
Main Clock
     |
     +------> Clock Gate ----> Bank0 Clock
     |
     +------> Clock Gate ----> Bank1 Clock
     |
     +------> Clock Gate ----> Bank2 Clock
     |
     +------> Clock Gate ----> Bank3 Clock
```

Banks without active accesses do not receive clock transitions after the timeout period expires.

---

# Data Flow

The architecture follows the sequence below.

1. Processor generates read and write requests.
2. Address decoding identifies the accessed register bank.
3. Bank Access Generator produces the bank access vector.
4. Access Monitor updates the activity counters.
5. Bank Enable signals remain asserted while counters are active.
6. Clock Gating generates gated clocks.
7. The Banked Register File performs the requested operation.
8. Read data is returned to the processor.

---

# Design Advantages

The modular organization provides several advantages.

- Clear separation of functionality
- Easy RTL debugging
- Independent verification of each module
- Scalable architecture for future enhancements
- Simplified maintenance and documentation
- Suitable foundation for research extensions

---

# Current Limitations

The current implementation provides activity-aware clock gating but does not yet include advanced adaptive mechanisms.

Future versions will introduce:

- Fetch-stage awareness
- Adaptive threshold control
- Instruction-based prediction
- Dynamic power estimation
- FPGA validation