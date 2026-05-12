# Calculator Testbench - Quick Reference

## Quick Start (3 Steps)

1. **Install OSS CAD Suite**
   - Download: https://github.com/YosysHQ/oss-cad-suite/releases
   - Extract to: `C:\oss-cad-suite`

2. **Run Tests**
   ```cmd
   cd Receptor\src
   run_simulation.bat
   ```

3. **View Waveforms**
   ```cmd
   view_waveforms.bat
   ```

---

## Test Commands

| Command | Purpose |
|---------|---------|
| `run_simulation.bat` | Compile & run all tests |
| `view_waveforms.bat` | Open GTKWave viewer |
| `make test-calc` | Run via Make (if installed) |
| `make wv-calc` | Run & view via Make |

---

## 11 Test Groups Summary

### ✓ Test 1: Basic Addition
- **Math**: 5 + 3 = 8
- **Keys**: 5 # 3 A
- **Validates**: Basic arithmetic

### ✓ Test 2: Reset
- **Action**: Clear/reset calculator
- **Key**: *
- **Validates**: FSM reset

### ✓ Test 3: Two-Digit
- **Math**: 42 + 17 = 59
- **Keys**: 4 2 # 1 7 A
- **Validates**: Multi-digit input

### ✓ Test 4: Three-Digit
- **Math**: 256 + 123 = 379
- **Keys**: 2 5 6 # 1 2 3 A
- **Validates**: Maximum input

### ✓ Test 5: Carry
- **Math**: 099 + 001 = 100
- **Keys**: 0 9 9 # 0 0 1 A
- **Validates**: BCD carry

### ✓ Test 6: Max Values
- **Math**: 999 + 999 = 1998
- **Keys**: 9 9 9 # 9 9 9 A
- **Validates**: Overflow handling

### ✓ Test 7: Zero
- **Math**: 000 + 000 = 000
- **Keys**: 0 # 0 A
- **Validates**: Zero handling

### ✓ Test 8: Mid-Operation Cancel
- **Math**: 5#3* then 7#2A
- **Keys**: 5 # 3 * 7 # 2 A
- **Validates**: Partial reset

### ✓ Test 9: Display Selection
- **Monitor**: display_sel[1:0]
- **States**: ESPERA(0) → INGRESO_NUM1(0) → INGRESO_NUM2(1) → SUMA(2)
- **Validates**: State transitions

### ✓ Test 10: Keypad Scanning
- **Monitor**: col[3:0] signal
- **Pattern**: 1110 → 1101 → 1011 → 0111
- **Validates**: Column scanner

### ✓ Test 11: All Single Digits
- **Math**: 0+0 through 9+9
- **Count**: 10 operations
- **Validates**: All digits work

---

## Key Codes Reference

| Key | Code | Use |
|-----|------|-----|
| 0-9 | 0-9 | Enter digits |
| # | 13 | Separator |
| A | 10 | Equals/Add |
| * | 14 | Clear |

---

## FSM State Machine (Quick Ref)

```
┌────────┐
│ ESPERA │  display=0, Press [0-9]
│ (Wait) │  ↓
└────────┘
    ↓
┌──────────────┐
│ INGRESO_NUM1 │  display=0, Collect first number
│ (Input Num1) │  Press # to advance
└──────────────┘
    ↓
┌──────────────┐
│ INGRESO_NUM2 │  display=1, Collect second number
│ (Input Num2) │  Press A to add
└──────────────┘
    ↓
┌──────┐
│ SUMA │  display=2, Show result
│(Sum) │  Press * to reset
└──────┘
```

---

## BCD Format Examples

| Decimal | BCD (Hex) | Bits |
|---------|-----------|------|
| 5 | 0x005 | 0000_0000_0101 |
| 42 | 0x042 | 0000_0100_0010 |
| 256 | 0x256 | 0010_0101_0110 |
| 999 | 0x999 | 1001_1001_1001 |
| 1998 | 0x1998 | 0001_1001_1001_1000 |

---

## Waveform Signals

| Signal | Width | Type | Notes |
|--------|-------|------|-------|
| clk | 1 | Input | 50 MHz |
| rst | 1 | Input | Active high |
| row | 4 | Input | Keypad rows |
| col | 4 | Output | Keypad columns |
| key_value | 4 | Output | 0-15 |
| key_valid | 1 | Output | Strobe |
| num1 | 12 | Output | BCD format |
| num2 | 12 | Output | BCD format |
| result | 16 | Output | BCD format |
| display_sel | 2 | Output | 0,1,2 |
| seg | 7 | Output | 7-segment |
| anode | 4 | Output | Digit select |

---

## Expected Test Results

```
✓ Passed All Tests

Total Tests: 50+
Passed: 50+
Failed: 0
Success Rate: 100%
```

---

## Performance Metrics

- **Simulation Time**: 5-10 seconds
- **VCD File Size**: 1-5 MB
- **Memory Usage**: ~100-200 MB
- **Test Execution**: ~3000 clock cycles

---

## File Locations

| File | Location | Purpose |
|------|----------|---------|
| Testbench | `src/sim/calculator_full_tb.sv` | Main tests |
| Run Script | `src/run_simulation.bat` | Execute tests |
| View Script | `src/view_waveforms.bat` | Display waveforms |
| Makefile | `src/build/Makefile` | Build targets |
| Output | `src/build/calculator_full_tb.vcd` | Waveforms |
| Docs | `README_TESTS.md` | Full documentation |

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "iverilog not found" | Install OSS CAD Suite |
| "Module not found" | Run from `src/` directory |
| "VCD file not found" | Run `run_simulation.bat` first |
| No waveforms | Check `src/build/` for .vcd file |
| Compilation fails | Check all .sv files exist in `design/` |

---

## Typical Session

```bash
# 1. Install tools (first time only)
# Download OSS CAD Suite

# 2. Run tests
cd Receptor\src
run_simulation.bat

# Output:
# ==========================================
# CALCULATOR COMPREHENSIVE TEST SUITE
# ==========================================
# 
# Compiling testbench and design modules...
# [SUCCESS] Compilation complete!
# 
# Running comprehensive calculator tests...
# 
# ✓ TEST 1: Simple Addition: 5 + 3 = 8
# ✓ TEST 2: Reset Test: Clear
# ✓ TEST 3: Two-digit: 42 + 17 = 59
# ...
# 
# ==========================================
# SIMULATION COMPLETE!
# ==========================================
# 
# VCD file: build\calculator_full_tb.vcd

# 3. View waveforms
view_waveforms.bat

# 4. Inspect signals in GTKWave
```

---

## Key Verification Points

- [ ] Clock toggling at 50MHz
- [ ] Reset clears all values
- [ ] Key inputs generate valid strobes
- [ ] Keypad scanner cycles columns
- [ ] FSM transitions correctly
- [ ] Numbers accumulate properly
- [ ] BCD addition produces correct results
- [ ] Display selection follows FSM state
- [ ] Carry propagates in addition
- [ ] 7-segment outputs valid data

---

## Terminal Test Output Format

```
╔════════════════════════════════════════════════════════╗
║     CALCULATOR COMPREHENSIVE TEST SUITE (4-digit BCD) ║
╚════════════════════════════════════════════════════════╝

▶ TEST GROUP 1: Simple Addition (5 + 3 = 8)
  Input Sequence: 5 # 3 A
  Result: num1=0x005, num2=0x003, result=0x0008

[... more tests ...]

╔════════════════════════════════════════════════════════╗
║                     TEST SUMMARY                      ║
╠════════════════════════════════════════════════════════╣
║ Total Tests Run:     XX                              ║
║ Passed:              XX ✓                            ║
║ Failed:              0 ✗                             ║
║ Success Rate:      100.0%                            ║
╚════════════════════════════════════════════════════════╝
```

---

## Quick Reference Card (Print This!)

```
CALCULATOR TESTBENCH - QUICK REFERENCE

Install OSS CAD Suite:
  → https://github.com/YosysHQ/oss-cad-suite/releases

Run Tests:
  → cd Receptor\src
  → run_simulation.bat

View Waveforms:
  → view_waveforms.bat

Key Mappings:
  0-9 = Digits    # = Separator    A = Equals    * = Clear

11 Test Groups:
  ✓ Basic (5+3)      ✓ Carry (99+1)        ✓ Display
  ✓ Reset            ✓ Max (999+999)       ✓ Scan
  ✓ 2-Digit (42+17)  ✓ Zero               ✓ All Digits
  ✓ 3-Digit (256+123)✓ Cancel

Expected Result:
  100% Pass Rate | All 50+ Tests Pass
```

---

## Contact & Support

For documentation, see:
- `README_TESTS.md` - Full test guide
- `CALCULATOR_TESTBENCH_DOCUMENTATION.md` - Complete reference
- `INSTALL_OSS_CAD_SUITE.md` - Installation help

---

**Version**: 1.0  
**Date**: May 11, 2026  
**Status**: ✓ Ready to Test
