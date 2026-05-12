# Find OSS CAD Suite
$toolsPath = $null
$possiblePaths = @(
    "C:\Users\$env:USERNAME\Downloads\oss-cad-suite\bin",
    "C:\oss-cad-suite\bin",
    "C:\Program Files\oss-cad-suite\bin",
    "C:\Program Files (x86)\oss-cad-suite\bin"
)

foreach ($path in $possiblePaths) {
    if (Test-Path "$path\iverilog.exe") {
        $toolsPath = $path
        Write-Host "Found OSS CAD Suite at: $toolsPath"
        break
    }
}

if ($toolsPath) {
    $env:PATH = "$toolsPath;$env:PATH"
} elseif (-not (Get-Command iverilog -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: iverilog not found"
    exit 1
}

# Navigate to build directory
Push-Location ".."

# Define source files
$sourceFiles = @(
    "design\top.sv",
    "design\debounce.sv",
    "design\col_scanner.sv",
    "design\keypad_decoder.sv",
    "design\input_fsm.sv",
    "design\adder.sv",
    "design\display_mux.sv",
    "design\bcd_to_7seg.sv"
)

$testbench = "sim\calculator_full_tb.sv"

Write-Host ""
Write-Host "=========================================="
Write-Host "CALCULATOR COMPREHENSIVE TEST SUITE"
Write-Host "=========================================="
Write-Host ""
Write-Host "Compiling testbench and design files..."
Write-Host ""

# Create build output directory
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# Compile
$compileArgs = @(
    "-o", "build\calculator_test.o",
    "-s", "calculator_full_tb",
    "-g2005-sv",
    $testbench
) + $sourceFiles

iverilog @compileArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Compilation failed!"
    Pop-Location
    exit 1
}

Write-Host ""
Write-Host "Compilation successful!"
Write-Host ""
Write-Host "Running comprehensive calculator tests..."
Write-Host ""

# Run simulation
vvp build\calculator_test.o

Write-Host ""
Write-Host "Simulation complete!"
Write-Host "VCD file: build\calculator_full_tb.vcd"
Write-Host ""

Pop-Location

