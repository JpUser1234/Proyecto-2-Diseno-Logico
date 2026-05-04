module keypad_tb;

reg clk, rst;
reg [3:0] row;
wire [3:0] col;
wire [6:0] seg;
wire [3:0] anode;

// Acceso a señales internas para debugging
wire [3:0] key_value;
wire key_valid;
wire [11:0] num1, num2;

top dut (
    .clk(clk),
    .rst(rst),
    .row(row),
    .col(col),
    .seg(seg),
    .anode(anode)
);

// Asignaciones para ver señales internas
assign key_value = dut.DECODER.key_value;
assign key_valid = dut.DECODER.key_valid;
assign num1 = dut.FSM.num1;
assign num2 = dut.FSM.num2;

// Clock 27 MHz: período = 37.037 ns
initial begin
    clk = 0;
    forever #18.5 clk = ~clk;
end

task press_key(input [3:0] row_val);
    begin
        row = row_val;
        repeat(16) @(posedge clk);  // Mantener presión durante 16 ciclos
        row = 4'b1111;              // Soltar
        repeat(50) @(posedge clk);  // Esperar a que se libere
    end
endtask

initial begin
    $dumpfile("keypad_tb.vcd");
    $dumpvars(0, keypad_tb);
    
    $display("===============================================");
    $display("Testbench: Prueba del Teclado con Ciclos de Reloj");
    $display("===============================================");
    
    // Reset
    rst = 1;
    row = 4'b1111;
    #200;
    rst = 0;
    #200;
    
    $display("\n--- Presionando tecla 1 (row=0001, col=0001) ---");
    press_key(4'b0001);
    $display("Time: %0t | num1=%d | key_valid=%b | key_value=%d", $time, num1, key_valid, key_value);
    
    #1000;
    
    $display("\n--- Presionando tecla 2 (row=0001, col=0010) ---");
    press_key(4'b0001);
    $display("Time: %0t | num1=%d | key_valid=%b | key_value=%d", $time, num1, key_valid, key_value);
    
    #1000;
    
    $display("\n--- Presionando # (row=0001, col=1000) para cambiar a num2 ---");
    press_key(4'b0001);
    $display("Time: %0t | num1=%d | key_valid=%b | key_value=%d", $time, num1, key_valid, key_value);
    
    #1000;
    
    $display("\n--- Presionando tecla 3 (row=0010, col=0001) ---");
    press_key(4'b0010);
    $display("Time: %0t | num2=%d | key_valid=%b | key_value=%d", $time, num2, key_valid, key_value);
    
    #1000;
    $display("\nFin de la simulación");
    $finish;
end

endmodule
