module display_mux (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  digit0,
    input  wire [3:0]  digit1,
    input  wire [3:0]  digit2,
    input  wire [3:0]  digit3,
    output reg  [3:0]  anode,
    output reg  [3:0]  digit_out
);

localparam MAX_COUNT = 27_000; // ~1 kHz
reg [14:0] counter;
reg [1:0] sel;

always_ff @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        sel <= 0;
    end else begin
        counter <= counter + 1;
        if (counter == MAX_COUNT-1) begin
            counter <= 0;
            sel <= sel + 1;
        end
    end
end

always_comb begin
    case (sel)
        2'd0: begin anode = 4'b1110; digit_out = digit0; end  // Display 0 activo (ACTIVA ALTA)
        2'd1: begin anode = 4'b1101; digit_out = digit1; end  // Display 1 activo
        2'd2: begin anode = 4'b1011; digit_out = digit2; end  // Display 2 activo
        2'd3: begin anode = 4'b0111; digit_out = digit3; end  // Display 3 activo
    endcase
end

endmodule