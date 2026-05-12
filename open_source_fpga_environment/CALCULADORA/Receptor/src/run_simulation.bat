@echo off
REM ============================================================================
REM Calculator Simulation Runner - Windows Batch Script
REM ============================================================================
REM This script runs the comprehensive calculator testbench simulation
REM Requirements: OSS CAD Suite (iverilog, vvp)
REM ============================================================================

setlocal enabledelayedexpansion

REM Try to find OSS CAD Suite
set "FOUND_TOOLS=0"
set "TOOLS_PATH="

if exist "C:\Users\%USERNAME%\Downloads\oss-cad-suite\bin\iverilog.exe" (
    set "TOOLS_PATH=C:\Users\%USERNAME%\Downloads\oss-cad-suite\bin"
    set "FOUND_TOOLS=1"
)

if exist "C:\oss-cad-suite\bin\iverilog.exe" (
    set "TOOLS_PATH=C:\oss-cad-suite\bin"
    set "FOUND_TOOLS=1"
)

if exist "%ProgramFiles%\oss-cad-suite\bin\iverilog.exe" (
    set "TOOLS_PATH=%ProgramFiles%\oss-cad-suite\bin"
    set "FOUND_TOOLS=1"
)

if "!FOUND_TOOLS!"=="1" (
    echo [SUCCESS] Found OSS CAD Suite at: !TOOLS_PATH!
    set "PATH=!TOOLS_PATH!;!PATH!"
) else (
    echo [ERROR] OSS CAD Suite not found!
    echo.
    echo Please install OSS CAD Suite:
    echo 1. Download from: https://github.com/YosysHQ/oss-cad-suite/releases
    echo 2. Extract to C:\oss-cad-suite (or %ProgramFiles%\oss-cad-suite)
    echo 3. Run this script again
    echo.
    pause
    exit /b 1
)

REM Navigate to src directory
cd /d "%~dp0"

if not exist "design" (
    echo [ERROR] design directory not found
    echo Please run this script from the Receptor\src directory
    pause
    exit /b 1
)

if not exist "sim\calculator_full_tb.sv" (
    echo [ERROR] calculator_full_tb.sv not found
    echo Please ensure the testbench file exists in sim/
    pause
    exit /b 1
)

echo.
echo ==========================================
echo CALCULATOR COMPREHENSIVE TEST SUITE
echo ==========================================
echo.
echo Compiling testbench and design modules...
echo.

REM Compile simulation
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

if errorlevel 1 (
    echo [FAILED] Compilation error!
    pause
    exit /b 1
)

echo [SUCCESS] Compilation complete!
echo.
echo Running comprehensive calculator tests...
echo.

REM Run simulation
vvp build\calculator_test.o

echo.
echo ==========================================
echo SIMULATION COMPLETE!
echo ==========================================
echo.
echo VCD file: build\calculator_full_tb.vcd
echo.
echo To view waveforms:
echo   gtkwave build\calculator_full_tb.vcd
echo.
pause
