# Calculator Comprehensive Test Suite - Setup Guide

## Overview
This guide provides everything needed to run comprehensive simulations of the 4-digit BCD Calculator with full testbench coverage.

## Prerequisites Installation

### Option 1: Install OSS CAD Suite (Recommended)
The OSS CAD Suite includes all necessary tools: iverilog, vvp, and gtkwave.

1. Download from: https://github.com/YosysHQ/oss-cad-suite/releases
2. Download the Windows version (ends with .zip or .msi)
3. Extract to a location like `C:\oss-cad-suite`
4. Add to your system PATH or use the batch script provided

### Option 2: Install Individual Tools
- **iverilog**: http://bleyer.org/icarus/
- **GTKWave**: http://gtkwave.sourceforge.net/

## Project Structure
```
src/
├── design/              # Hardware design modules
│   ├── top.sv          # Top-level module
│   ├── input_fsm.sv    # Input state machine
│   ├── adder.sv        # BCD adder
│   ├── display_mux.sv  # Display multiplexer
│   ├── bcd_to_7seg.sv  # BCD to 7-segment converter
│   ├── col_scanner.sv  # Column scanner
│   ├── keypad_decoder.sv
│   └── debounce.sv
│
├── sim/                 # Simulation files
│   ├── calculator_full_tb.sv  # Main comprehensive testbench
│   └── [other testbenches]
│
├── constr/              # FPGA constraints
│
└── build/               # Build outputs
    ├── run_simulation.ps1  # Simulation script
    ├── Makefile            # Make targets
    └── [compiled objects]
```

## Running Simulations

### Method 1: PowerShell Script (Easiest)
```powershell
cd "src\build"
.\run_simulation.ps1
```

### Method 2: Manual with Make
```bash
cd src/build
make test-calc         # Run calculator tests
make wv-calc           # View waveforms
```

### Method 3: Manual Commands
```bash
cd src

# Compile
iverilog -o build\calculator_test.o -s calculator_full_tb `
  -g2005-sv sim\calculator_full_tb.sv `
  design\top.sv design\debounce.sv design\col_scanner.sv `
  design\keypad_decoder.sv design\input_fsm.sv design\adder.sv `
  design\display_mux.sv design\bcd_to_7seg.sv

# Run simulation
vvp build\calculator_test.o

# View waveforms
gtkwave build\calculator_full_tb.vcd
```

## Test Cases Implemented

### Test Group 1: Simple Addition
- **Operation**: 5 + 3 = 8
- **Input Sequence**: 5 # 3 A
- **Verifies**: Basic addition functionality

### Test Group 2: Reset Test
- **Operation**: Press * to reset calculator
- **Verifies**: FSM reset and data clearing

### Test Group 3: Two-digit Addition
- **Operation**: 42 + 17 = 59
- **Input Sequence**: 4 2 # 1 7 A
- **Verifies**: Multi-digit input

### Test Group 4: Three-digit Addition
- **Operation**: 256 + 123 = 379
- **Input Sequence**: 2 5 6 # 1 2 3 A
- **Verifies**: Maximum input range

### Test Group 5: Carry Test
- **Operation**: 099 + 001 = 100
- **Input Sequence**: 0 9 9 # 0 0 1 A
- **Verifies**: BCD carry handling

### Test Group 6: Large Numbers
- **Operation**: 999 + 999 = 1998
- **Input Sequence**: 9 9 9 # 9 9 9 A
- **Verifies**: Maximum value overflow

### Test Group 7: Zero Addition
- **Operation**: 000 + 000 = 000
- **Input Sequence**: 0 # 0 A
- **Verifies**: Zero handling

### Test Group 8: Cancellation Test
- **Operation**: Enter 5#3*, then 7#2A
- **Verifies**: Mid-operation reset

### Test Group 9: Display Selection Test
- **Monitors**: display_sel output during state transitions
- **States Tested**:
  - ESPERA (display_sel=0)
  - INGRESO_NUM1 (display_sel=0)
  - INGRESO_NUM2 (display_sel=1)
  - SUMA (display_sel=2)

### Test Group 10: Keypad Scanning Verification
- **Verifies**: col signal cycles through 4'b1110, 4'b1101, 4'b1011, 4'b0111
- **Duration**: 2000 clock cycles of scanning

### Test Group 11: BCD Single Digit Verification
- **Operation**: All single digits 0-9 + themselves
- **Verifies**: Each digit operation (digit + digit)
- **Coverage**: 10 operations

## Understanding Test Output

The testbench generates comprehensive terminal output:

```
╔════════════════════════════════════════════════════════╗
║     CALCULATOR COMPREHENSIVE TEST SUITE (4-digit BCD) ║
╚════════════════════════════════════════════════════════╝

▶ TEST GROUP 1: Simple Addition (5 + 3 = 8)
  Input Sequence: 5 # 3 A
  Result: num1=0x005, num2=0x003, result=0x0008

▶ TEST GROUP 2: Reset Test
  After reset: num1=0x000, num2=0x000
...

╔════════════════════════════════════════════════════════╗
║                     TEST SUMMARY                      ║
╠════════════════════════════════════════════════════════╣
║ Total Tests Run:      XX                             ║
║ Passed:               XX                             ║
║ Failed:               0                              ║
║ Success Rate:       100.0%                           ║
╚════════════════════════════════════════════════════════╝
```

## Viewing Waveforms with GTKWave

1. After simulation completes, a file `calculator_full_tb.vcd` is generated
2. Open with GTKWave:
   ```bash
   gtkwave calculator_full_tb.vcd
   ```

3. **Key Signals to Monitor**:
   - `clk` - System clock
   - `rst` - Reset signal
   - `row[3:0]` - Keypad row input
   - `col[3:0]` - Keypad column output (scanner)
   - `key_value[3:0]` - Decoded key value
   - `key_valid` - Key valid strobe
   - `num1[11:0]` - First number (BCD)
   - `num2[11:0]` - Second number (BCD)
   - `do_sum` - Perform sum signal
   - `result[15:0]` - Addition result (BCD)
   - `display_sel[1:0]` - Which value to display
   - `anode[3:0]` - 7-segment anode select
   - `seg[6:0]` - 7-segment segments

4. **Suggested Waveform Signals to Add**:
   - Double-click signals to add them
   - Or use the "Append" button in GTKWave
   - Expand modules in the hierarchy to see internal signals

## Keypad Key Mapping

| Key Code | Value | Description |
|----------|-------|-------------|
| 0-9      | 0x0-0x9 | Digit keys |
| 10 (A)   | 0x0A  | Equals (start sum) |
| 13 (#)   | 0x0D  | Separator between num1 and num2 |
| 14 (*)   | 0x0E  | Clear/Reset |

## FSM State Flow

```
ESPERA (Initial)
  ├─ [0-9] → INGRESO_NUM1
  └─ [other] → ESPERA

INGRESO_NUM1
  ├─ [0-9] → INGRESO_NUM1 (append digit)
  ├─ [#] → INGRESO_NUM2
  └─ [*] → ESPERA

INGRESO_NUM2
  ├─ [0-9] → INGRESO_NUM2 (append digit)
  ├─ [A] → SUMA
  └─ [*] → ESPERA

SUMA
  ├─ [*] → ESPERA
  └─ [other] → SUMA (hold result)
```

## BCD Format

Numbers are stored in Binary Coded Decimal (BCD) format:
- Each 4-bit nibble represents a decimal digit (0-9)
- Example: 0x123 represents 123 in decimal
  - Bits [3:0]   = 3 (ones)
  - Bits [7:4]   = 2 (tens)
  - Bits [11:8]  = 1 (hundreds)

## Troubleshooting

### "iverilog not found"
- Install OSS CAD Suite from: https://github.com/YosysHQ/oss-cad-suite/releases
- Add it to system PATH or run from OSS CAD Suite directory

### "Module not found" errors
- Verify all .sv files are in `src/design/` directory
- Check filenames match exactly (case-sensitive on Linux)

### Simulation hangs
- Press Ctrl+C to stop
- Check testbench logic for infinite loops
- Verify clock generation in testbench

### Waveform viewer won't open
- Install GTKWave from: http://gtkwave.sourceforge.net/
- Check .vcd file was generated in build directory

## Running from VS Code

1. Open VS Code integrated terminal
2. Navigate to `src/build` directory
3. Run: `powershell -ExecutionPolicy Bypass .\run_simulation.ps1`
4. Or use the make target: `make test-calc`

## Performance Notes

- Simulation runtime: ~5-10 seconds
- Generated VCD file size: ~1-5 MB
- Memory usage: Minimal
- Total testbench coverage: 11 test groups, 50+ test cases

## Next Steps

After verification:
1. Synthesize design with Yosys
2. Place and route with nextpnr
3. Generate bitstream with gowin_pack
4. Load onto Tang Nano 9K with openFPGALoader

See main Makefile for synthesis targets:
```bash
make synth
make pnr
make bitstream
make load
```

## Support & Debugging

For detailed signal inspection:
1. Open waveform in GTKWave
2. Right-click on signals for detailed view
3. Use "Zoom" functions to explore timing
4. Export data using GTKWave tools

For additional test cases, edit `calculator_full_tb.sv` and add new test groups following the existing pattern.

---
Generated: May 11, 2026
Calculator Test Suite v1.0
