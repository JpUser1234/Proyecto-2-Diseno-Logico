module debouncer_check_tb;

reg clk, rst;
reg [3:0] row;
wire [3:0] col;
wire [6:0] seg;
wire [3:0] anode;

top dut (
    .clk(clk),
    .rst(rst),
    .row(row),
    .col(col),
    .seg(seg),
    .anode(anode)
);

// Clock 27 MHz
initial begin
    clk = 0;
    forever #18.5 clk = ~clk;
end

integer i;

initial begin
    $dumpfile("debouncer_check_tb.vcd");
    $dumpvars(0, debouncer_check_tb);
    
    $display("===============================================");
    $display("Testbench: Verificar salida de debouncer");
    $display("N=19 requiere 2^19 = 262143 ciclos (~9.7ms)");
    $display("===============================================");
    
    // Reset
    rst = 1;
    row = 4'b1111;
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(20) @(posedge clk);
    
    $display("\nSalida del debouncer inicialmente (debería ser 1111):");
    $display("row_clean[0]=%b, row_clean[1]=%b, row_clean[2]=%b, row_clean[3]=%b",
             dut.deb_rows[0].DEB.DB_out,
             dut.deb_rows[1].DEB.DB_out,
             dut.deb_rows[2].DEB.DB_out,
             dut.deb_rows[3].DEB.DB_out);
    
    $display("\n--- Presionando tecla 1: row[0]=1 (lógica activa alta, invertida) durante 300000 ciclos ---");
    row = 4'b0001;  // Con inversión: row=0001 significa presionado (lógica activa ALTA)
    
    for (i=0; i<300000; i=i+30000) begin
        repeat(30000) @(posedge clk);
        $display("Ciclos: %d | row=%b | row_clean[0]=%b | col=%b | key_valid=%b",
                 i+30000, row,
                 dut.deb_rows[0].DEB.DB_out,
                 dut.SCANNER.col_scan,
                 dut.DECODER.key_valid);
    end
    
    row = 4'b1111;  // Soltar
    $display("\n--- Tecla soltada ---");
    repeat(100) @(posedge clk);
    
    $display("\n--- Fin ---");
    $finish;
end

endmodule
