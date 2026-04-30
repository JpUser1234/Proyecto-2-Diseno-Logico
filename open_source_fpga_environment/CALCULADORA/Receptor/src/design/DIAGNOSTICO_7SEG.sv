/*
GUÍA DE DIAGNÓSTICO: 7 SEGMENTOS NO MUESTRA "0"

SÍNTOMA: Usuario ve "b b b" y apagado cuando debería ver "0 0 0 0"

POSIBLES CAUSAS:

1. LÓGICA INVERTIDA EN SEGMENTOS (seg[6:0])
   Si los LEDs están al revés (0=encendido en lugar de 1=encendido):
   - Necesitas invertir TODOS los patrones de bcd_to_7seg
   - Cambiar: seg = 7'b1111110 → seg = 7'b0000001 (para 0)
   
   VERIFICACIÓN: ¿Los otros dígitos (1,2,3...) se muestran INVERTIDOS en los displays?

2. LÓGICA INVERTIDA EN ANODOS (anode[3:0])
   Si los transistores están configurados al revés (0=activo en lugar de 1=activo):
   - Necesitas invertir TODOS los patrones de display_mux
   - Cambiar: anode = 4'b1110 → anode = 4'b0001 (para display 0)
   
   VERIFICACIÓN: ¿Los displays se iluminan todos juntos o ninguno?
   ¿El display "correcto" se ilumina cuando esperarías el opuesto?

3. MULTIPLEXING INCORRECTO
   Si display_mux está mostrando el mismo dígito en todos los displays:
   - El problema está en la velocidad del multiplexing o la lógica de anode
   
   VERIFICACIÓN: ¿Todos los displays muestran idéntico?

4. CONEXIÓN FÍSICA INCORRECTA
   Si los pines de los LED o del anode están intercambiados:
   - Necesitas verificar la PCB/protoboard y las conexiones
   
   VERIFICACIÓN: ¿Algunos LEDs se encienden pero no forman patrones reconocibles?

PRÓXIMOS PASOS:
1. Identifica cuál de los síntomas coincide con tu situación
2. Proporciona más detalles: ¿Todos los displays muestran lo mismo? 
   ¿Solo algunos LEDs se encienden? ¿Se encienden/apagan rápidamente?
*/

// Plantilla: Si necesitas invertir la lógica de segmentos
module bcd_to_7seg_inverted (
    input  wire [3:0] digit,
    output reg  [6:0] seg
);

always_comb begin
    case (digit)
        4'd0: seg = 7'b0000001;  // Invertido: antes 1111110
        4'd1: seg = 7'b1001111;
        4'd2: seg = 7'b0010010;
        4'd3: seg = 7'b0000110;
        4'd4: seg = 7'b1001100;
        4'd5: seg = 7'b0100100;
        4'd6: seg = 7'b0100000;
        4'd7: seg = 7'b0001111;
        4'd8: seg = 7'b0000000;
        4'd9: seg = 7'b0000100;
        default: seg = 7'b1111111;  // Invertido: antes 0000000
    endcase
end

endmodule

// Plantilla: Si necesitas invertir la lógica de anodos
// En display_mux, cambiar:
// Cambiar anode = 4'bXXXX → anode = ~4'bXXXX
// Ejemplo:
// 2'd0: begin anode = ~4'b1110; digit_out = digit0; end
// 2'd1: begin anode = ~4'b1101; digit_out = digit1; end
// 2'd2: begin anode = ~4'b1011; digit_out = digit2; end
// 2'd3: begin anode = ~4'b0111; digit_out = digit3; end
