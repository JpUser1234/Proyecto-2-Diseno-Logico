module top_minimal_tb;

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
    forever #18.5 clk = ~clk;  // ~27 MHz
end

initial begin
    $dumpfile("top_minimal_tb.vcd");
    $dumpvars(0, top_minimal_tb);
    
    $display("Top Module Minimal Test - No Inputs");
    $display("Time | Anode | Seg[6:0] | Expected for 0");
    $display("-----|-------|----------|----------------");
    
    // Reset
    rst = 1;
    row = 4'b1111;  // No buttons pressed (pullups)
    #100;
    rst = 0;
    
    // Observe for several cycles (includes display switching ~27 times at 1kHz)
    repeat (100) begin
        #37000;  // Wait ~1ms between observations
        $display("%5d | %b | %b | 1111110 (0)", $time, anode, seg);
    end
    
    #1000;
    $finish;
end

endmodule
