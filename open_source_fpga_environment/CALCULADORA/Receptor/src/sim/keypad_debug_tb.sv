module keypad_debug_tb;

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
    $dumpfile("keypad_debug_tb.vcd");
    $dumpvars(0, keypad_debug_tb);
    
    $display("===============================================");
    $display("DEBUG: Monitoreando col_scanner y keypad_decoder");
    $display("===============================================");
    
    // Reset
    rst = 1;
    row = 4'b1111;
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(20) @(posedge clk);
    
    $display("\n--- Presionando tecla 1 durante 16 ciclos ---");
    $display("Time %0t: row=0001", $time);
    row = 4'b0001;
    
    repeat(40) begin
        @(posedge clk);
        $display("Time %0t: row=%b | col=%b | key_valid=%b | key_value=%d", 
                 $time, row, 
                 dut.SCANNER.col_scan, 
                 dut.DECODER.key_valid,
                 dut.DECODER.key_value);
    end
    
    row = 4'b1111;
    $display("\nTime %0t: row=1111 (tecla liberada)", $time);
    
    repeat(30) @(posedge clk);
    $display("\n--- Fin ---");
    $finish;
end

endmodule
