/*
DIAGNÓSTICO PARA DISPLAYS SIN SALIDA

Tienes 4 configuraciones posibles:
1. ORIGINAL (antes de cambios)
2. Segmentos activa baja + Anodes activa alta (actual - que probaste)
3. Segmentos activa alta + Anodes activa baja  
4. Ambos activa baja (lo que probaste primero)

INSTRUCCIONES:
Si la config actual NO muestra nada, prueba las siguientes alternativas:

OPCIÓN A - Revertir TODO a original:
- En bcd_to_7seg.sv: usa los patrones que estaban ANTES (1111110, 0110000, etc)
- En display_mux.sv: usa anodes = 1110, 1101, 1011, 0111

OPCIÓN B - Solo invertir segmentos:
- Mantener segmentos activa baja (como está ahora)
- Mantener anodes activa alta (como está ahora después de revert)

OPCIÓN C - Solo invertir anodes:
- Revertir segmentos a activa alta (patrones originales)
- Cambiar anodes a activa baja (0001, 0010, 0100, 1000)

PRUEBA SISTEMÁTICA:
1. Compila con cada opción
2. Carga en FPGA
3. Reporta: ¿Muestra algo? ¿Qué ves?
4. ¿Reacciona a teclas?
*/

// OPCIÓN A - ORIGINAL (revert completamente)
module bcd_to_7seg_original (
    input  wire [3:0] digit,
    output reg  [6:0] seg
);
always_comb begin
    case (digit)
        4'd0: seg = 7'b1111110;
        4'd1: seg = 7'b0110000;
        4'd2: seg = 7'b1101101;
        4'd3: seg = 7'b1111001;
        4'd4: seg = 7'b0110011;
        4'd5: seg = 7'b1011011;
        4'd6: seg = 7'b1011111;
        4'd7: seg = 7'b1110000;
        4'd8: seg = 7'b1111111;
        4'd9: seg = 7'b1111011;
        default: seg = 7'b0000000;
    endcase
end
endmodule

// OPCIÓN C - Solo invertir anodes
module display_mux_option_c (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  digit0, digit1, digit2, digit3,
    output reg  [3:0]  anode,
    output reg  [3:0]  digit_out
);
localparam MAX_COUNT = 27_000;
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
        2'd0: begin anode = 4'b0001; digit_out = digit0; end  // Anodes activa baja
        2'd1: begin anode = 4'b0010; digit_out = digit1; end
        2'd2: begin anode = 4'b0100; digit_out = digit2; end
        2'd3: begin anode = 4'b1000; digit_out = digit3; end
    endcase
end
endmodule
