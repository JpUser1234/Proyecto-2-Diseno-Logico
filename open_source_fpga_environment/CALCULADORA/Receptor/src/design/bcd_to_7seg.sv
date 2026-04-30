module bcd_to_7seg (
    input  wire [3:0] digit,
    output reg  [6:0] seg    // seg[6]=a, seg[5]=b, ..., seg[0]=g
);

always_comb begin
    seg = 7'b1111111;
end

endmodule