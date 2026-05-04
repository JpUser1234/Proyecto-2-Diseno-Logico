module diagnostic_tb;

reg clk, rst;
reg [3:0] row;
wire [3:0] col;
wire [6:0] seg;
wire [3:0] anode;

integer i;
integer found_pulse;

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
    $dumpfile("diagnostic_tb.vcd");
    $dumpvars(0, diagnostic_tb);

    $display("===============================================");
    $display("DIAGNÓSTICO: Verificar cada componente");
    $display("===============================================");

    // Reset
    rst = 1;
    row = 4'b0000;
    repeat(10) @(posedge clk);
    rst = 0;
    repeat(100) @(posedge clk);

    $display("\n--- 1. Verificar col_scanner ---");
    $display("col_scan debería rotar: 0001 -> 1000 -> 0100 -> 0010 -> 0001");
    repeat(5) begin
        repeat(27000) @(posedge clk);  // Un ciclo completo de col_scanner
        $display("col_scan = %b", dut.SCANNER.col_scan);
    end

    $display("\n--- 2. Verificar debounce (sin presionar) ---");
    $display("row_clean debería ser 0000 (pull-down)");
    $display("row_clean = %b (esperado: 0000)", {dut.deb_rows[3].DEB.DB_out, dut.deb_rows[2].DEB.DB_out, dut.deb_rows[1].DEB.DB_out, dut.deb_rows[0].DEB.DB_out});

    $display("\n--- 3. Simular presión de tecla ---");
    $display("Configurando row = 0001 (presionar fila 0)");
    row = 4'b0001;

    // Esperar debounce (~2^14 ciclos / 27MHz ≈ 0.6 ms)
    found_pulse = 0;
    for (i = 0; i < 40000; i = i + 1) begin
        @(posedge clk);
        if (dut.DECODER.key_valid) begin
            found_pulse = 1;
            $display("PULSO key_valid detectado en %0t | row_clean=%b | col_scan=%b | col_latched=%b | key_value=%d | num1=%d",
                     $time,
                     {dut.deb_rows[3].DEB.DB_out, dut.deb_rows[2].DEB.DB_out, dut.deb_rows[1].DEB.DB_out, dut.deb_rows[0].DEB.DB_out},
                     dut.SCANNER.col_scan, dut.DECODER.col_latched, dut.DECODER.key_value, dut.FSM.num1);
        end
    end

    $display("Después de debounce:");
    $display("row = %b", row);
    $display("row_clean = %b (esperado: 0001)", {dut.deb_rows[3].DEB.DB_out, dut.deb_rows[2].DEB.DB_out, dut.deb_rows[1].DEB.DB_out, dut.deb_rows[0].DEB.DB_out});
    $display("col_scan = %b", dut.SCANNER.col_scan);
    $display("key_valid = %b (esperado: 1)", dut.DECODER.key_valid);
    $display("key_value = %d (esperado: 1)", dut.DECODER.key_value);
    $display("num1 = %d (esperado: 1)", dut.FSM.num1);
    if (!found_pulse) $display("No se detectó pulso key_valid durante la ventana de debounce");

    $display("\n--- Observando señales durante 50 ciclos ---");
    repeat (50) begin
        @(posedge clk);
        $display("Time=%0t | row_clean=%b | col_scan=%b | key_valid=%b | key_value=%d | num1=%d", 
                 $time, {dut.deb_rows[3].DEB.DB_out, dut.deb_rows[2].DEB.DB_out, dut.deb_rows[1].DEB.DB_out, dut.deb_rows[0].DEB.DB_out},
                 dut.SCANNER.col_scan, dut.DECODER.key_valid, dut.DECODER.key_value, dut.FSM.num1);
    end

    $display("\n--- 4. Verificar display ---");
    $display("seg = %b", seg);
    $display("anode = %b", anode);

    $display("\n--- 5. Soltar tecla ---");
    row = 4'b0000;
    repeat(100) @(posedge clk);

    $display("Después de soltar:");
    $display("key_valid = %b (esperado: 0)", dut.DECODER.key_valid);
    $display("num1 = %d (debería mantenerse en 1)", dut.FSM.num1);

    $display("\n===============================================");
    $display("RESUMEN DE DIAGNÓSTICO:");
    $display("- Si col_scan rota correctamente: OK");
    $display("- Si row_clean cambia a 0001: debounce OK");
    $display("- Si key_valid=1 y key_value=1: decoder OK");
    $display("- Si num1=1: FSM OK");
    $display("- Si seg cambia: display OK");
    $display("===============================================");

    $finish;
end

endmodule
