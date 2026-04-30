module bcd_to_7seg_tb;

reg [3:0] digit;
wire [6:0] seg;

bcd_to_7seg dut (
    .digit(digit),
    .seg(seg)
);

initial begin
    $dumpfile("bcd_to_7seg_tb.vcd");
    $dumpvars(0, bcd_to_7seg_tb);
    
    $display("BCD to 7-Seg Pattern Verification");
    $display("digit | seg[6:0] (binary) | Expected | Status");
    $display("------|------------------|----------|--------");
    
    // Prueba cada dígito
    for (digit = 0; digit <= 9; digit = digit + 1) begin
        #1;
        case (digit)
            0: $display("  %d   | %b       |  1111110 | %s", digit, seg, (seg == 7'b1111110) ? "OK" : "FAIL");
            1: $display("  %d   | %b       |  0110000 | %s", digit, seg, (seg == 7'b0110000) ? "OK" : "FAIL");
            2: $display("  %d   | %b       |  1101101 | %s", digit, seg, (seg == 7'b1101101) ? "OK" : "FAIL");
            3: $display("  %d   | %b       |  1111001 | %s", digit, seg, (seg == 7'b1111001) ? "OK" : "FAIL");
            4: $display("  %d   | %b       |  0110011 | %s", digit, seg, (seg == 7'b0110011) ? "OK" : "FAIL");
            5: $display("  %d   | %b       |  1011011 | %s", digit, seg, (seg == 7'b1011011) ? "OK" : "FAIL");
            6: $display("  %d   | %b       |  1011111 | %s", digit, seg, (seg == 7'b1011111) ? "OK" : "FAIL");
            7: $display("  %d   | %b       |  1110000 | %s", digit, seg, (seg == 7'b1110000) ? "OK" : "FAIL");
            8: $display("  %d   | %b       |  1111111 | %s", digit, seg, (seg == 7'b1111111) ? "OK" : "FAIL");
            9: $display("  %d   | %b       |  1111011 | %s", digit, seg, (seg == 7'b1111011) ? "OK" : "FAIL");
        endcase
    end
    
    #1;
    $finish;
end

endmodule
