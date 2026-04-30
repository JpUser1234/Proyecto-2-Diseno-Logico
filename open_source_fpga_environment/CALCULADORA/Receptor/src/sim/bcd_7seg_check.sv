module bcd_7seg_check;
// Verificar qué patrón vemos como "b b b"
// "b" = dígito 2 = 1101101 en el código actual

reg [3:0] digit;
wire [6:0] seg, seg_inv;

bcd_to_7seg dut (
    .digit(digit),
    .seg(seg)
);

// Invertido para lógica activa baja
assign seg_inv = ~seg;

initial begin
    $display("BCD to 7-Seg Analysis - Active Low vs Active High");
    $display("");
    $display("Si el usuario ve 'b' (dígito 2) cuando espera '0':");
    $display("");
    
    // Mostrar patrones para dígito 2
    digit = 4'd2;
    #1;
    $display("Dígito 2 - Lógica ACTIVA ALTA (actual):");
    $display("  seg[6:0] = %b", seg);
    $display("  seg[6:0] = %0d (decimal)", seg);
    $display("");
    
    // Mostrar patrones para dígito 0
    digit = 4'd0;
    #1;
    $display("Dígito 0 - Lógica ACTIVA ALTA (esperado):");
    $display("  seg[6:0] = %b", seg);
    $display("  seg[6:0] = %0d (decimal)", seg);
    $display("");
    
    // Si fuera activa baja
    digit = 4'd2;
    #1;
    $display("Dígito 2 - Lógica ACTIVA BAJA (invertida):");
    $display("  seg[6:0] = %b", seg_inv);
    $display("");
    
    digit = 4'd0;
    #1;
    $display("Dígito 0 - Lógica ACTIVA BAJA (invertida):");
    $display("  seg[6:0] = %b", seg_inv);
    
    $finish;
end

endmodule
