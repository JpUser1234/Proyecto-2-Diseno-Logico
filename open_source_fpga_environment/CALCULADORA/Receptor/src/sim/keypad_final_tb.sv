module keypad_final_tb;

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

initial begin
    $dumpfile("keypad_final_tb.vcd");
    $dumpvars(0, keypad_final_tb);
    
    $display("===============================================");
    $display("Testbench FINAL: Prueba con presión estabilizada");
    $display("===============================================");
    
    // Reset
    rst = 1;
    row = 4'b0000;  // Lógica activa ALTA: 0000=sin presionar
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(100) @(posedge clk);  // Esperar a que todo se estabilice
    
    $display("\n--- Presionando tecla (row[0]=1) durante 50000 ciclos ---");
    row = 4'b0001;  // Lógica activa alta: 0001=row[0] presionado
    repeat(50000) @(posedge clk);
    
    $display("Time %0t: Observando cambios en displays...", $time);
    repeat(1000) @(posedge clk);
    
    row = 4'b0000;  // Soltar
    $display("Time %0t: Tecla soltada", $time);
    repeat(200) @(posedge clk);
    
    $display("\n--- Presionando otra tecla (row[1]=1) ---");
    row = 4'b0010;
    repeat(50000) @(posedge clk);
    repeat(1000) @(posedge clk);
    row = 4'b0000;
    repeat(200) @(posedge clk);
    
    $display("\n--- Fin ---");
    $finish;
end

// Monitor
wire [3:0] row_clean_all = {dut.deb_rows[3].DEB.DB_out, dut.deb_rows[2].DEB.DB_out, 
                             dut.deb_rows[1].DEB.DB_out, dut.deb_rows[0].DEB.DB_out};
wire [11:0] num1_val = dut.FSM.num1;

initial begin
    $monitor("Time=%0t | row=%b | row_clean=%b | col=%b | key_valid=%b | num1=%d", 
             $time, row, row_clean_all, 
             dut.SCANNER.col_scan, 
             dut.DECODER.key_valid,
             num1_val);
end

endmodule
