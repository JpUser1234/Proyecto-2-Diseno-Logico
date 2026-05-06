module keypad_decoder (
    input wire clk,
    input wire rst,
    input wire [3:0] row,
    input wire [3:0] col,
    output reg [3:0] key_value,
    output reg key_valid
);

reg [3:0] row_prev;
reg key_busy;   // 🔒 LOCK GLOBAL

always_ff @(posedge clk) begin
    if (!rst) begin
        row_prev  <= 0;
        key_valid <= 0;
        key_value <= 0;
        key_busy  <= 0;
    end else begin

        key_valid <= 0;

        // ============================
        // DETECCIÓN DE TECLA NUEVA
        // ============================
        if (row != 0 && row_prev == 0 && !key_busy) begin

            key_busy  <= 1;     // 🔒 bloquea repetición
            key_valid <= 1;

            case ({row, col})
                8'b0001_0001: key_value <= 4'd1;
                8'b0001_0010: key_value <= 4'd4;
                8'b0001_0100: key_value <= 4'd7;
                8'b0001_1000: key_value <= 4'd14;

                8'b0010_0001: key_value <= 4'd2;
                8'b0010_0010: key_value <= 4'd5;
                8'b0010_0100: key_value <= 4'd8;
                8'b0010_1000: key_value <= 4'd0;

                8'b0100_0001: key_value <= 4'd3;
                8'b0100_0010: key_value <= 4'd6;
                8'b0100_0100: key_value <= 4'd9;
                8'b0100_1000: key_value <= 4'd13;

                8'b1000_0001: key_value <= 4'd10;
                8'b1000_0010: key_value <= 4'd11;
                8'b1000_0100: key_value <= 4'd12;
                8'b1000_1000: key_value <= 4'd15;

                default: key_valid <= 0;
            endcase
        end

        // ============================
        // LIBERAR TECLA (CUANDO SUELTAS)
        // ============================
        if (row == 0)
            key_busy <= 0;

        row_prev <= row;
    end
end

endmodule