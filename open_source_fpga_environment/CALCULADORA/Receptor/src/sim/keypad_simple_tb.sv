module keypad_simple_tb;

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

// Clock 27 MHz: período = 37.037 ns
initial begin
    clk = 0;
    forever #18.5 clk = ~clk;
end

initial begin
    $dumpfile("keypad_simple_tb.vcd");
    $dumpvars(0, keypad_simple_tb);
    
    $display("===============================================");
    $display("Testbench: Prueba del Teclado");
    $display("===============================================");
    
    // Reset
    rst = 1;
    row = 4'b1111;
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(20) @(posedge clk);
    
    $display("\n--- Presionando tecla 1 (row=0001 durante 16 ciclos) ---");
    $display("Time %0t: Presionando tecla...", $time);
    row = 4'b0001;
    repeat(16) @(posedge clk);
    row = 4'b1111;
    $display("Time %0t: Tecla liberada", $time);
    repeat(50) @(posedge clk);
    
    $display("\n--- Presionando tecla 2 (row=0001 durante 16 ciclos) ---");
    $display("Time %0t: Presionando tecla...", $time);
    row = 4'b0001;
    repeat(16) @(posedge clk);
    row = 4'b1111;
    $display("Time %0t: Tecla liberada", $time);
    repeat(50) @(posedge clk);
    
    $display("\n--- Fin de la simulación ---");
    $finish;
end

// Monitor de salidas
initial begin
    $monitor("Time=%0t | col=%b | seg=%b | anode=%b", 
             $time, col, seg, anode);
end

endmodule
