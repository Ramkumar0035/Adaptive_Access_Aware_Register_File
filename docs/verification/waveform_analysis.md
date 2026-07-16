# Waveform Analysis

## Overview

Simulation waveforms were analyzed to verify the functional correctness of the Adaptive Access-Aware Register File. The captured waveforms demonstrate correct register operations, adaptive bank activation, counter behavior, and clock gating.

---

# Waveform 1 – Initial Register Writes

## Objective

Verify successful write operations into all four register banks.

### Observation

- Data was written into:
  - x3 (Bank0)
  - x10 (Bank1)
  - x18 (Bank2)
  - x29 (Bank3)

- The corresponding bank access bit was asserted.
- The access monitor loaded the counter to the threshold value.
- The associated bank enable signal became active.

### Result

✅ Register writes completed successfully.

---

# Waveform 2 – Dual Read Operation

## Objective

Verify simultaneous reads from two different banks.

### Observation

- Two read ports accessed different register banks.
- Both read values were returned correctly.
- The bank access vector reflected both active banks.

### Result

✅ Dual-port read functionality verified.

---

# Waveform 3 – Adaptive Counter Operation

## Objective

Verify counter loading and countdown.

### Observation

- Counter initialized to the threshold after an access.
- Counter decremented once per clock cycle.
- Bank remained enabled while the counter was non-zero.
- Bank was disabled when the counter reached zero.

### Result

✅ Adaptive timeout mechanism verified.

---

# Waveform 4 – Continuous Bank Access

## Objective

Verify counter reload during continuous accesses.

### Observation

- Consecutive accesses reloaded the counter.
- The bank enable signal remained continuously asserted.
- The bank was never disabled while accesses continued.

### Result

✅ Counter reload functionality verified.

---

# Waveform 5 – Clock Gating

## Objective

Verify selective clock propagation.

### Observation

- Enabled banks received gated clock pulses.
- Disabled banks received no clock transitions.
- Each bank operated independently.

### Result

✅ Clock gating operated correctly.

---

# Waveform 6 – Multi-Bank Access

## Objective

Verify simultaneous accesses across multiple banks.

### Observation

- Multiple bank access bits were asserted simultaneously.
- Independent bank enable signals were generated.
- Multiple banks remained active concurrently.

### Result

✅ Multi-bank operation verified.

---

# Waveform 7 – x0 Register Protection

## Objective

Verify RISC-V x0 behavior.

### Observation

- Writes to x0 were ignored.
- Reads from x0 always returned zero.

### Result

✅ RISC-V compliance verified.

---

# Waveform 8 – Read After Write

## Objective

Verify correct data availability after a write.

### Observation

- A register was updated.
- The subsequent read returned the newly written value.

### Result

✅ Read-after-write behavior verified.

---

# Waveform 9 – Final Verification

## Observation

Simulation completed successfully with:

- Zero functional errors
- Correct bank access generation
- Correct bank enable generation
- Proper counter operation
- Successful clock gating
- Correct register read/write operations

### Result

✅ All verification tests passed.

---

# Summary

The simulation waveforms confirm that the Adaptive Access-Aware Register File operates as intended. All major functional blocks—including register banking, adaptive access monitoring, clock gating, and RISC-V register behavior—were validated successfully through directed verification.