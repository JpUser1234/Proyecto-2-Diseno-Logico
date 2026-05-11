# 📚 COMPREHENSIVE TESTBENCH - COMPLETE FILE INDEX

## 🎯 START HERE

Read in this order:

1. **First Time Setup** → [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md)
2. **Overview** → [TESTBENCH_GENERATION_SUMMARY.md](TESTBENCH_GENERATION_SUMMARY.md)
3. **Quick Start** → [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

Then execute: `cd Receptor\src && run_simulation.bat`

---

## 📖 Documentation Files

### Project Root Directory

```
Proyecto-2-Diseno-Logico/
│
├─ 📄 INDEX.md (you are here)
│  └─ Navigation guide for all files
│
├─ 🚀 TESTBENCH_GENERATION_SUMMARY.md
│  └─ Complete overview of what was generated
│  └─ Architecture and workflow diagrams
│  └─ Next steps and integration guide
│
├─ 📚 CALCULATOR_TESTBENCH_DOCUMENTATION.md
│  └─ Complete reference manual
│  └─ Test descriptions
│  └─ Signal specifications
│  └─ FSM state machine details
│
├─ ⚡ QUICK_REFERENCE.md
│  └─ Quick start (3 steps)
│  └─ Command reference
│  └─ Test summary table
│  └─ Printable cheat sheet
│
├─ 🔧 INSTALL_OSS_CAD_SUITE.md
│  └─ Step-by-step installation
│  └─ Windows PATH configuration
│  └─ Troubleshooting
│  └─ Docker alternative
│
└─ README.md (original project README)
```

---

## 🎯 Testbench Files

### Design Under Test (DUT)

Located in: `open_source_fpga_environment/CALCULADORA/Receptor/src/design/`

```
design/
├─ 📌 top.sv .......................... Top-level module
│  └─ Instantiates all submodules
│  └─ Connects interfaces
│
├─ 🤖 input_fsm.sv .................... Input state machine
│  └─ ESPERA → INGRESO_NUM1 → INGRESO_NUM2 → SUMA
│
├─ ➕ adder.sv ........................ BCD adder
│  └─ Performs 3-digit BCD addition
│  └─ Handles carries
│
├─ 🎛️ display_mux.sv ................. Display multiplexer
│  └─ Selects which value to display
│  └─ Handles digit rotation
│
├─ 7️⃣ bcd_to_7seg.sv ................. BCD to 7-segment converter
│  └─ Digit to segment encoding
│
├─ 📟 col_scanner.sv ................. Column scanner
│  └─ Keypad column sequencing
│
├─ 🔍 keypad_decoder.sv .............. Keypad decoder
│  └─ Row-column to key value
│
└─ 🔘 debounce.sv (x4) ............... Debouncer module
   └─ Removes noise from row inputs
```

### Testbench File

Located in: `open_source_fpga_environment/CALCULADORA/Receptor/src/sim/`

```
sim/
└─ ⭐ calculator_full_tb.sv .......... MAIN TESTBENCH
   ├─ 11 test groups
   ├─ 50+ test cases
   ├─ ~350 lines of SystemVerilog
   ├─ Press key simulation
   ├─ Result verification
   ├─ Waveform generation
   └─ Test report formatting
```

---

## 🔨 Build & Execution Files

Located in: `open_source_fpga_environment/CALCULADORA/Receptor/src/`

```
src/
├─ 🖥️ run_simulation.bat ............ Windows batch script
│  └─ One-click test execution
│  └─ Auto-finds OSS CAD Suite
│  └─ Compiles testbench
│  └─ Runs simulation
│
├─ 👁️ view_waveforms.bat ........... GTKWave launcher
│  └─ Opens waveform viewer
│  └─ Auto-finds .vcd file
│
└─ build/
   ├─ 📋 Makefile ................... Build configuration (UPDATED)
   │  ├─ make test-calc
   │  ├─ make test-calc-verbose
   │  ├─ make test-calc-wave
   │  ├─ make wv-calc
   │  └─ make test-all
   │
   ├─ 🔌 run_simulation.ps1 ........ PowerShell alternative
   │
   ├─ 📊 calculator_full_tb.vcd .... Generated waveforms
   │  └─ Created after simulation
   │  └─ Open with GTKWave
   │
   └─ 🏗️ calculator_test.o ......... Compiled object
      └─ Created during compilation
```

---

## 📖 Quick Navigation by Task

### "I want to run tests"
1. Install OSS CAD Suite → [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md)
2. Execute: `cd Receptor\src && run_simulation.bat`
3. View results in terminal

### "I want to view waveforms"
1. Run: `run_simulation.bat`
2. Then: `view_waveforms.bat`
3. Or: `gtkwave build\calculator_full_tb.vcd`

### "I want to understand the tests"
→ [README_TESTS.md](open_source_fpga_environment/CALCULADORA/Receptor/README_TESTS.md)
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

### "I want complete documentation"
→ [CALCULATOR_TESTBENCH_DOCUMENTATION.md](CALCULATOR_TESTBENCH_DOCUMENTATION.md)

### "I want a quick reference"
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) (printable!)

### "I'm having installation issues"
→ [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md) → Troubleshooting section

### "I want to customize tests"
1. Edit: `Receptor/src/sim/calculator_full_tb.sv`
2. Add new test group (follow existing pattern)
3. Recompile: `run_simulation.bat`

---

## 🧪 Test Groups Quick Reference

```
TEST 1  | 5 + 3 = 8           | Basic arithmetic
TEST 2  | Clear/Reset         | FSM reset
TEST 3  | 42 + 17 = 59        | Two-digit input
TEST 4  | 256 + 123 = 379     | Three-digit input
TEST 5  | 099 + 001 = 100     | Carry handling
TEST 6  | 999 + 999 = 1998    | Overflow handling
TEST 7  | 000 + 000 = 000     | Zero handling
TEST 8  | 5#3*7#2A            | Mid-operation cancel
TEST 9  | State monitoring    | Display selection
TEST 10 | Column scanning     | Keypad scanner
TEST 11 | 0+0 through 9+9     | All single digits
```

---

## 📊 Signal Reference

### Key Signals to Monitor in GTKWave

| Signal | Bus Width | Type | Description |
|--------|-----------|------|-------------|
| clk | 1 | Input | 50 MHz system clock |
| rst | 1 | Input | Active-high reset |
| row[3:0] | 4 | Input | Keypad row inputs |
| col[3:0] | 4 | Output | Keypad column scanner |
| key_value[3:0] | 4 | Output | Decoded key value (0-15) |
| key_valid | 1 | Output | Key valid strobe |
| num1[11:0] | 12 | Output | First number (BCD) |
| num2[11:0] | 12 | Output | Second number (BCD) |
| do_sum | 1 | Output | Perform addition signal |
| result[15:0] | 16 | Output | Addition result (BCD) |
| display_sel[1:0] | 2 | Output | Which value to display (0,1,2) |
| anode[3:0] | 4 | Output | 7-segment anode select |
| seg[6:0] | 7 | Output | 7-segment segments |

---

## 🎓 Learning Path

### For First-Time Users
1. Read: [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
2. Install OSS CAD Suite per [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md)
3. Run: `run_simulation.bat`
4. View: `view_waveforms.bat`
5. Read: [README_TESTS.md](open_source_fpga_environment/CALCULADORA/Receptor/README_TESTS.md)

### For Advanced Users
1. Read: [CALCULATOR_TESTBENCH_DOCUMENTATION.md](CALCULATOR_TESTBENCH_DOCUMENTATION.md)
2. Edit: `calculator_full_tb.sv`
3. Add custom test cases
4. Integrate with CI/CD

### For Integration
1. Read: [TESTBENCH_GENERATION_SUMMARY.md](TESTBENCH_GENERATION_SUMMARY.md)
2. Review: Makefile targets
3. Integrate with synthesis flow
4. Add to version control

---

## 📋 File Size & Structure

```
Documentation Files:
├─ INSTALL_OSS_CAD_SUITE.md .............. ~300 lines
├─ TESTBENCH_GENERATION_SUMMARY.md ....... ~400 lines
├─ CALCULATOR_TESTBENCH_DOCUMENTATION.md  ~500 lines
├─ README_TESTS.md ....................... ~350 lines
├─ QUICK_REFERENCE.md ................... ~300 lines
└─ INDEX.md (this file) .................. ~350 lines
   TOTAL: ~2,200 lines of documentation

Code Files:
├─ calculator_full_tb.sv ................. ~350 lines (GENERATED)
├─ run_simulation.bat .................... ~70 lines (GENERATED)
├─ view_waveforms.bat .................... ~40 lines (GENERATED)
└─ Makefile additions .................... ~50 lines (UPDATED)
   TOTAL: ~510 lines of code
```

---

## 🔍 Finding Specific Information

### Signal Timing
→ Generate waveforms and view in GTKWave

### Test Details
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → "11 Test Groups Summary"

### FSM State Transitions
→ [CALCULATOR_TESTBENCH_DOCUMENTATION.md](CALCULATOR_TESTBENCH_DOCUMENTATION.md) → "FSM State Machine"

### BCD Format Examples
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → "BCD Format Examples"

### Keypad Key Codes
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → "Key Codes Reference"

### Installation Steps
→ [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md)

### Troubleshooting
→ [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md) → "Troubleshooting"

### Run Commands
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md) → "Test Commands"

---

## 🚀 Typical Workflow

```
Day 1: Initial Setup
├─ Download OSS CAD Suite
├─ Extract to C:\oss-cad-suite
├─ Verify iverilog works
└─ Run: run_simulation.bat

Day 2: Analysis
├─ Review test results
├─ Open GTKWave
├─ Inspect waveforms
├─ Verify functionality
└─ Document verification

Day 3+: Integration
├─ Add to CI/CD
├─ Customize tests
├─ Generate reports
└─ Proceed with synthesis
```

---

## ✅ Verification Checklist

Use this to verify everything was generated correctly:

```
□ calculator_full_tb.sv exists in src/sim/
□ run_simulation.bat exists in src/
□ view_waveforms.bat exists in src/
□ All documentation files present
□ Makefile has new test targets
□ OSS CAD Suite installed
□ iverilog command works
□ Simulation runs to completion
□ VCD file is generated
□ GTKWave can open VCD file
□ All test groups execute
□ Test summary shows 100% pass
```

---

## 📞 Support & Troubleshooting

| Issue | Reference |
|-------|-----------|
| Installation help | [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md) |
| Test details | [README_TESTS.md](open_source_fpga_environment/CALCULADORA/Receptor/README_TESTS.md) |
| Complete reference | [CALCULATOR_TESTBENCH_DOCUMENTATION.md](CALCULATOR_TESTBENCH_DOCUMENTATION.md) |
| Quick commands | [QUICK_REFERENCE.md](QUICK_REFERENCE.md) |
| What was generated | [TESTBENCH_GENERATION_SUMMARY.md](TESTBENCH_GENERATION_SUMMARY.md) |

---

## 🎯 Next Steps

### Ready to Test?
```bash
cd Receptor\src
run_simulation.bat
```

### Need Installation Help?
→ [INSTALL_OSS_CAD_SUITE.md](INSTALL_OSS_CAD_SUITE.md)

### Want Full Details?
→ [CALCULATOR_TESTBENCH_DOCUMENTATION.md](CALCULATOR_TESTBENCH_DOCUMENTATION.md)

### Need a Quick Start?
→ [QUICK_REFERENCE.md](QUICK_REFERENCE.md)

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| Test Groups | 11 |
| Test Cases | 50+ |
| Lines of Code (testbench) | ~350 |
| Lines of Documentation | ~2,200 |
| Total Files Generated | 7 |
| Coverage | Comprehensive |
| Expected Pass Rate | 100% |

---

**Generated**: May 11, 2026  
**Status**: ✅ COMPLETE  
**Ready to Use**: YES

---

## 🗺️ Site Map

```
INDEX.md (START HERE)
│
├─→ QUICK_REFERENCE.md (Quick Start)
│
├─→ INSTALL_OSS_CAD_SUITE.md (Setup)
│
├─→ TESTBENCH_GENERATION_SUMMARY.md (Overview)
│
├─→ CALCULATOR_TESTBENCH_DOCUMENTATION.md (Full Manual)
│
├─→ README_TESTS.md (Test Details)
│   │
│   └─→ Receptor/src/sim/calculator_full_tb.sv (Testbench Code)
│       │
│       └─→ design/*.sv (Design Modules)
│
├─→ Receptor/src/run_simulation.bat (Execute)
│
└─→ Receptor/src/view_waveforms.bat (Visualize)
```

---

**Everything is ready! 🎉**

Start with: `cd Receptor\src && run_simulation.bat`
