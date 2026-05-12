# OSS CAD Suite Installation Guide for Windows

## Quick Installation

### Step 1: Download OSS CAD Suite
1. Visit: https://github.com/YosysHQ/oss-cad-suite/releases
2. Look for the latest release
3. Download: `oss-cad-suite-windows-x64-[date].zip` (or similar)
4. File size: ~500-700 MB

### Step 2: Extract to Known Location
- **Recommended**: `C:\oss-cad-suite`
- **Alternative**: `C:\Users\YourUsername\Downloads\oss-cad-suite`
- **Or**: `C:\Program Files\oss-cad-suite`

Example:
```
C:\oss-cad-suite\
├── bin/              (contains iverilog.exe, vvp.exe, gtkwave.exe, etc.)
├── lib/
├── share/
└── [other files]
```

### Step 3: Verify Installation
1. Open Command Prompt or PowerShell
2. Run:
   ```cmd
   set PATH=C:\oss-cad-suite\bin;%PATH%
   iverilog -V
   ```
3. Should show version information like:
   ```
   Icarus Verilog version 10.3 (stable) (v10_3)
   Copyright 1998-2020 Stephen Williams
   ...
   ```

## Option A: Add to System PATH (Recommended)

### Windows 10/11:
1. Press `Win + X` and select "System"
2. Click "Advanced system settings"
3. Click "Environment Variables"
4. Under "System variables", click "New"
5. Variable name: `PATH`
6. Variable value: `C:\oss-cad-suite\bin`
7. Click OK and restart command prompt

### Alternative - PowerShell:
```powershell
# Run as Administrator
[Environment]::SetEnvironmentVariable(
    "PATH",
    [Environment]::GetEnvironmentVariable("PATH","Machine") + ";C:\oss-cad-suite\bin",
    "Machine"
)
```

## Option B: Use Batch File (No System PATH needed)

Use the provided `run_simulation.bat` file - it automatically finds and sets up the tools.

## Testing the Installation

After installation, run the batch file:
```cmd
cd Receptor\src
run_simulation.bat
```

Or test manually:
```cmd
set PATH=C:\oss-cad-suite\bin;%PATH%

cd Receptor\src
iverilog -o build\calculator_test.o -s calculator_full_tb -g2005-sv ^
    sim\calculator_full_tb.sv ^
    design\top.sv ^
    design\debounce.sv ^
    design\col_scanner.sv ^
    design\keypad_decoder.sv ^
    design\input_fsm.sv ^
    design\adder.sv ^
    design\display_mux.sv ^
    design\bcd_to_7seg.sv

vvp build\calculator_test.o

gtkwave build\calculator_full_tb.vcd
```

## Troubleshooting

### "iverilog command not found"
- Verify OSS CAD Suite is installed in correct location
- Check PATH is set correctly
- Restart command prompt/PowerShell
- Try running from OSS CAD Suite bin directory

### Downloaded file is .7z or .tar
- Use 7-Zip to extract: http://www.7-zip.org/
- Or use Windows built-in: right-click → Extract All

### Permission denied errors
- Run command prompt as Administrator
- Check file permissions on oss-cad-suite directory

### GTKWave won't start
- If missing, you can install separately: http://gtkwave.sourceforge.net/
- Or it's included in the OSS CAD Suite

## Alternative: Use Docker (Advanced)

If you prefer containerized setup:
```powershell
docker pull hdlc/ubuntu20.04:latest
docker run -it hdlc/ubuntu20.04
```

Then inside container:
```bash
apt-get install -y gtkwave
cd /path/to/project
iverilog -o test.o -s calculator_full_tb -g2005-sv sim/calculator_full_tb.sv design/*.sv
vvp test.o
```

## Support

For issues with OSS CAD Suite:
- GitHub Issues: https://github.com/YosysHQ/oss-cad-suite/issues
- Documentation: https://github.com/YosysHQ/oss-cad-suite

For Icarus Verilog (iverilog) specifically:
- Website: http://bleyer.org/icarus/
- GitHub: https://github.com/steveicarus/iverilog

## Uninstallation

Simply delete the OSS CAD Suite directory:
```cmd
rmdir /s /q C:\oss-cad-suite
```

Then remove from PATH (if added to system environment variables).

---
Once installed, you can run the calculator tests using the provided scripts!
