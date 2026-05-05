module adder (
    input  wire        clk,
    input  wire        rst,
    input  wire        do_sum,
    input  wire [13:0] num1,
    input  wire [13:0] num2,
    output reg  [13:0] result
);

always_ff @(posedge clk) begin
    if (!rst)        // reset activo en bajo
        result <= 0;
    else if (do_sum)
        result <= num1 + num2;
end

endmodule