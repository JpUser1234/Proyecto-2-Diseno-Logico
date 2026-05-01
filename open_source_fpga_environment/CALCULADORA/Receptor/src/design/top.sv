module top (
    output wire [6:0] seg,
    output wire [3:0] anode
);

// Activa SOLO el primer display
assign anode = 4'b1110;

// Enciende SOLO el segmento A (seg[6])
assign seg = 7'b1000000;

endmodule