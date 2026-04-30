module keypad_decoder (
    input  wire [3:0] row,        // filas del teclado (sincronizadas)
    input  wire [3:0] col,        // columna activa del scanner
    output reg  [3:0] key_value,  // valor de la tecla 0-15
    output reg        key_valid   // 1 cuando hay tecla válida
);

always_comb begin
    key_valid = 1;
    key_value = 4'hF;  // valor por defecto

    case ({row, col})
        // Fila 0 (row = 0001)
        8'b0001_0001: key_value = 4'd1;   // tecla 1
        8'b0001_0010: key_value = 4'd2;   // tecla 2
        8'b0001_0100: key_value = 4'd3;   // tecla 3
        8'b0001_1000: key_value = 4'd10;  // tecla A
        // Fila 1 (row = 0010)
        8'b0010_0001: key_value = 4'd4;   // tecla 4
        8'b0010_0010: key_value = 4'd5;   // tecla 5
        8'b0010_0100: key_value = 4'd6;   // tecla 6
        8'b0010_1000: key_value = 4'd11;  // tecla B
        // Fila 2 (row = 0100)
        8'b0100_0001: key_value = 4'd7;   // tecla 7
        8'b0100_0010: key_value = 4'd8;   // tecla 8
        8'b0100_0100: key_value = 4'd9;   // tecla 9
        8'b0100_1000: key_value = 4'd12;  // tecla C
        // Fila 3 (row = 1000)
        8'b1000_0001: key_value = 4'd14;  // tecla * → limpiar
        8'b1000_0010: key_value = 4'd0;   // tecla 0
        8'b1000_0100: key_value = 4'd13;  // tecla # → confirmar num1
        8'b1000_1000: key_value = 4'd15;  // tecla D
        default: begin
            key_value = 4'hF;
            key_valid = 0;               // ninguna tecla presionada
        end
    endcase
end

endmodule