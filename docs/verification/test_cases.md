# Test Cases

## Overview

A comprehensive set of directed test cases was developed to validate the functionality of the Adaptive Access-Aware Register File. The tests verify correct register operation, adaptive bank activation, clock gating behavior, and compliance with the RISC-V register file specification.

---

# Test Summary

| Test ID | Description | Status |
|----------|-------------|--------|
| TC-01 | Initial Register Write | ✅ Pass |
| TC-02 | Dual Read Operation | ✅ Pass |
| TC-03 | Multi-Bank Read | ✅ Pass |
| TC-04 | Bank Enable Timeout | ✅ Pass |
| TC-05 | Continuous Bank Access | ✅ Pass |
| TC-06 | Counter Decrement | ✅ Pass |
| TC-07 | Same Bank Dual Read | ✅ Pass |
| TC-08 | Write-Only Operation | ✅ Pass |
| TC-09 | Clock Gating Validation | ✅ Pass |
| TC-10 | Counter Expiry | ✅ Pass |
| TC-11 | x0 Register Protection | ✅ Pass |
| TC-12 | Counter Reload | ✅ Pass |
| TC-13 | Bank Access Generation | ✅ Pass |
| TC-14 | Read After Write | ✅ Pass |
| TC-15 | Simultaneous Multi-Bank Access | ✅ Pass |
| TC-16 | Read and Write Same Register | ✅ Pass |
| TC-17 | Mixed Read and Write Across Banks | ✅ Pass |

---

# Test Descriptions

## TC-01 – Initial Register Write

### Objective

Verify that data is written correctly into all four register banks.

### Stimulus

Write values into:

- x3
- x10
- x18
- x29

### Expected Result

Each register stores the correct value in its corresponding bank.

**Result:** ✅ Pass

---

## TC-02 – Dual Read Operation

### Objective

Verify simultaneous reads from two different banks.

### Expected Result

Both read ports return the correct data in the same cycle.

**Result:** ✅ Pass

---

## TC-03 – Multi-Bank Read

### Objective

Verify concurrent accesses to different register banks.

### Expected Result

The correct bank access vector is generated and both reads complete successfully.

**Result:** ✅ Pass

---

## TC-04 – Bank Enable Timeout

### Objective

Verify that bank enable signals remain active for the configured timeout period after the last access.

### Expected Result

The enable signal stays asserted while the counter is non-zero and deasserts when the counter expires.

**Result:** ✅ Pass

---

## TC-05 – Continuous Bank Access

### Objective

Verify that repeated accesses reload the access counter.

### Expected Result

The counter reloads to the threshold value on every new access.

**Result:** ✅ Pass

---

## TC-06 – Counter Decrement

### Objective

Verify countdown behavior when no new accesses occur.

### Expected Result

Counters decrement every clock cycle until reaching zero.

**Result:** ✅ Pass

---

## TC-07 – Same Bank Dual Read

### Objective

Verify simultaneous reads from the same bank.

### Expected Result

Both read operations complete correctly.

**Result:** ✅ Pass

---

## TC-08 – Write-Only Operation

### Objective

Verify correct write behavior without any read activity.

### Expected Result

The target bank is updated correctly.

**Result:** ✅ Pass

---

## TC-09 – Clock Gating Validation

### Objective

Verify that only enabled banks receive gated clocks.

### Expected Result

Inactive banks receive no clock transitions.

**Result:** ✅ Pass

---

## TC-10 – Counter Expiry

### Objective

Verify automatic disabling of inactive banks after timeout.

### Expected Result

The bank enable signal deasserts when the counter reaches zero.

**Result:** ✅ Pass

---

## TC-11 – x0 Register Protection

### Objective

Verify compliance with the RISC-V x0 register specification.

### Expected Result

Writes to x0 are ignored and reads always return zero.

**Result:** ✅ Pass

---

## TC-12 – Counter Reload

### Objective

Verify that a new access reloads an active counter before it expires.

### Expected Result

The counter returns to the threshold value immediately after access.

**Result:** ✅ Pass

---

## TC-13 – Bank Access Generation

### Objective

Verify correct generation of the bank access vector for read and write operations.

### Expected Result

Only the accessed bank bits are asserted.

**Result:** ✅ Pass

---

## TC-14 – Read After Write

### Objective

Verify immediate availability of newly written data.

### Expected Result

The updated value is returned correctly.

**Result:** ✅ Pass

---

## TC-15 – Simultaneous Multi-Bank Access

### Objective

Verify simultaneous read and write operations across multiple banks.

### Expected Result

All accessed banks remain enabled independently.

**Result:** ✅ Pass

---

## TC-16 – Read and Write Same Register

### Objective

Verify correct behavior when the same register is read and written.

### Expected Result

The updated value is observed after the write operation.

**Result:** ✅ Pass

---

## TC-17 – Mixed Read and Write Across Banks

### Objective

Verify concurrent read and write operations involving multiple banks.

### Expected Result

Bank access generation, clock gating, and register updates operate correctly.

**Result:** ✅ Pass

---

# Verification Summary

| Metric | Result |
|--------|--------|
| Total Test Cases | 17 |
| Passed | 17 |
| Failed | 0 |
| Functional Errors | 0 |
| Bank Access Errors | 0 |
| Counter Overflow | 0 |
| Register Mismatch | 0 |

---

# Conclusion

All directed verification tests completed successfully. The register file, adaptive access monitor, bank access generator, and clock gating logic behaved as expected under both normal and corner-case operating conditions.