module hardware_test_tb;

reg clk, rst;
reg [3:0] row;
wire [3:0] col;
wire [6:0] seg;
wire [3:0] anode;

top dut (
    .clk(clk),
    .rst(rst),
    .row(row),
    .col(col),
    .seg(seg),
    .anode(anode)
);

// Clock 27 MHz
initial begin
    clk = 0;
    forever #18.5 clk = ~clk;
end

// Simular hardware real: filas con pull-down (inician en 0)
initial begin
    $dumpfile("hardware_test_tb.vcd");
    $dumpvars(0, hardware_test_tb);

    $display("===============================================");
    $display("TESTBENCH: Simulación de Hardware Real");
    $display("Filas inician en 0 (pull-down)");
    $display("Presionar tecla = fila va a 1");
    $display("===============================================");

    // Reset
    rst = 1;
    row = 4'b0000;  // Hardware real: pull-down = 0
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(100) @(posedge clk);  // Esperar estabilización

    $display("\n--- Estado inicial ---");
    $display("row=%b | col=%b | key_valid=%b | num1=%d",
             row, dut.SCANNER.col_scan, dut.DECODER.key_valid, dut.FSM.num1);

    // Esperar a que col_scan rote a 0001 (col[0] = 1)
    $display("\n--- Esperando col_scan = 0001 ---");
    while (dut.SCANNER.col_scan != 4'b0001) begin
        @(posedge clk);
    end
    $display("col_scan ahora es %b", dut.SCANNER.col_scan);

    // Simular presionar tecla en fila 0, columna 0 (tecla '1')
    $display("\n--- Presionando tecla '1' (row[0]=1) ---");
    row = 4'b0001;  // Solo fila 0 va a 1

    // Mantener presionado suficiente tiempo para debounce (N=14 = ~606µs)
    repeat(1000) @(posedge clk);  // Mucho más que suficiente

    $display("Después de debounce:");
    $display("row=%b | col=%b | key_valid=%b | key_value=%d | num1=%d",
             row, dut.SCANNER.col_scan, dut.DECODER.key_valid,
             dut.DECODER.key_value, dut.FSM.num1);

    // Soltar tecla
    $display("\n--- Soltando tecla ---");
    row = 4'b0000;
    repeat(100) @(posedge clk);

    $display("Después de soltar:");
    $display("row=%b | col=%b | key_valid=%b | num1=%d",
             row, dut.SCANNER.col_scan, dut.DECODER.key_valid, dut.FSM.num1);

    // Probar otra tecla
    $display("\n--- Presionando tecla '2' (row[0]=1, pero ahora col_scan podría estar en otra posición) ---");

    // Esperar a que col_scan vuelva a 0001
    while (dut.SCANNER.col_scan != 4'b0001) begin
        @(posedge clk);
    end

    row = 4'b0001;
    repeat(1000) @(posedge clk);

    $display("Tecla '2' resultado:");
    $display("row=%b | col=%b | key_valid=%b | key_value=%d | num1=%d",
             row, dut.SCANNER.col_scan, dut.DECODER.key_valid,
             dut.DECODER.key_value, dut.FSM.num1);

    row = 4'b0000;
    repeat(100) @(posedge clk);

    $display("\n--- Fin de test ---");
    $finish;
end

endmodule
