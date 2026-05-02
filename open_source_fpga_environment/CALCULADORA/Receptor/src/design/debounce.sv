module debounce #(
    parameter CLK_FREQ   = 27_000_000,
    parameter DEBOUNCE_MS = 20
)(
    input  wire clk,
    input  wire rst,
    input  wire signal_in,
    output reg  signal_clean
);

localparam MAX_COUNT = (CLK_FREQ/1000) * DEBOUNCE_MS;

reg [$clog2(MAX_COUNT)-1:0] counter;
reg state;

always_ff @(posedge clk) begin
    if (rst) begin
        counter      <= 0;
        state        <= 0;
        signal_clean <= 0;
    end else begin
        if (signal_in != state) begin
            counter <= counter + 1;
            if (counter == MAX_COUNT - 1) begin
                state        <= signal_in;
                signal_clean <= signal_in;
                counter      <= 0;
            end
        end else begin
            counter <= 0;
        end
    end
end

endmodule
