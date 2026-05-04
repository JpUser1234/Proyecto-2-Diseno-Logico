module keypad_fixed_tb;

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

initial begin
    $dumpfile("keypad_fixed_tb.vcd");
    $dumpvars(0, keypad_fixed_tb);
    
    $display("===============================================");
    $display("Testbench: Prueba con debounce correcto");
    $display("Debouncer requiere ~513 ciclos (N=19, 2^19)");
    $display("===============================================");
    
    // Reset
    rst = 1;
    row = 4'b1111;
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(20) @(posedge clk);
    
    $display("\n--- Presionando tecla 1 durante 600 ciclos (suficiente para debounce) ---");
    row = 4'b0001;
    repeat(600) @(posedge clk);
    row = 4'b1111;
    $display("Time %0t: Tecla liberada después de debounce", $time);
    
    repeat(200) @(posedge clk);
    
    $display("\n--- Presionando tecla 2 (misma fila, misma columna) durante 600 ciclos ---");
    row = 4'b0001;
    repeat(600) @(posedge clk);
    row = 4'b1111;
    $display("Time %0t: Tecla liberada", $time);
    
    repeat(200) @(posedge clk);
    
    $display("\n--- Fin de la simulación ---");
    $display("Observar seg y anode para cambios en displays");
    $finish;
end

// Monitor de salidas
initial begin
    $monitor("Time=%0t | row=%b | col=%b | seg=%b | anode=%b | key_valid=%b", 
             $time, row, dut.SCANNER.col_scan, seg, anode, dut.DECODER.key_valid);
end

endmodule
