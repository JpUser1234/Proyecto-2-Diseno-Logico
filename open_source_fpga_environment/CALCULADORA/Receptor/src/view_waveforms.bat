@echo off
REM ============================================================================
REM GTKWave Waveform Viewer Launcher
REM ============================================================================
REM This script finds and opens the calculator_full_tb.vcd waveform file
REM ============================================================================

setlocal enabledelayedexpansion

REM Find gtkwave executable
set "FOUND_GTKWAVE=0"

if exist "C:\oss-cad-suite\bin\gtkwave.exe" (
    set "GTKWAVE=C:\oss-cad-suite\bin\gtkwave.exe"
    set "FOUND_GTKWAVE=1"
)

if exist "C:\Program Files\GTKWave\gtkwave.exe" (
    set "GTKWAVE=C:\Program Files\GTKWave\gtkwave.exe"
    set "FOUND_GTKWAVE=1"
)

if "!FOUND_GTKWAVE!"=="0" (
    echo [ERROR] GTKWave not found!
    echo.
    echo GTKWave is included with OSS CAD Suite
    echo Install it from: https://github.com/YosysHQ/oss-cad-suite/releases
    echo.
    pause
    exit /b 1
)

REM Find VCD file
set "VCD_FILE=!CD!\build\calculator_full_tb.vcd"

if not exist "!VCD_FILE!" (
    echo [ERROR] VCD file not found at: !VCD_FILE!
    echo.
    echo Please run the simulation first:
    echo   run_simulation.bat
    echo.
    pause
    exit /b 1
)

echo [INFO] Opening waveform file...
echo File: !VCD_FILE!
echo Viewer: !GTKWAVE!
echo.

start "" "!GTKWAVE!" "!VCD_FILE!"

echo [SUCCESS] GTKWave launched!
