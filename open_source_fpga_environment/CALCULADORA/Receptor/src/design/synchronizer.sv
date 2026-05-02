module synchronizer (
    input  wire clk,
    input  wire rst,
    input  wire async_in,
    output reg  sync_out
);

reg stage1;

always_ff @(posedge clk) begin
    if (rst) begin
        stage1   <= 0;
        sync_out <= 0;
    end else begin
        stage1   <= async_in;
        sync_out <= stage1;
    end
end

endmodule