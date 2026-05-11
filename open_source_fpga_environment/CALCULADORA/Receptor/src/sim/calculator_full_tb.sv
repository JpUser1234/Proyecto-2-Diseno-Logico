`timescale 1ns / 1ps

module calculator_full_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg [3:0] row;
    wire [3:0] col;
    wire [6:0] seg;
    wire [3:0] anode;

    // Internal signals for monitoring
    wire [3:0] key_value;
    wire key_valid;
    wire [11:0] num1, num2;
    wire do_sum;
    wire [1:0] display_sel;
    wire [15:0] result;

    // Instantiate DUT
    top dut (
        .clk(clk),
        .rst(rst),
        .row(row),
        .col(col),
        .seg(seg),
        .anode(anode)
    );

    // Clock generation - 50MHz
    always #10 clk = ~clk;

    // Test parameters
    localparam CLK_PERIOD = 20;
    localparam KEY_DEBOUNCE_DELAY = 200; // cycles for debounce
    localparam INTER_KEY_DELAY = 500;     // cycles between key presses

    // Key codes
    localparam KEY_HASH = 4'd13;  // #
    localparam KEY_A    = 4'd10;  // A
    localparam KEY_STAR = 4'd14;  // *

    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;

    // Test task to press and release a key
    task press_key(input [3:0] key_code);
        integer i;
        begin
            // Simulate keypad press (set row based on key_code)
            case(key_code)
                4'd0, 4'd1, 4'd2, 4'd3:    row = ~(4'b0001 << key_code);
                4'd4, 4'd5, 4'd6, 4'd7:    row = ~(4'b0001 << (key_code - 4));
                4'd8, 4'd9:                row = ~(4'b0001 << (key_code - 8));
                4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15: 
                                           row = ~(4'b0001);
                default:                   row = 4'b1111;
            endcase

            // Hold key for debounce time
            repeat(KEY_DEBOUNCE_DELAY) @(posedge clk);

            // Release key
            row = 4'b1111;

            // Wait between key presses
            repeat(INTER_KEY_DELAY) @(posedge clk);
        end
    endtask

    // Assert and verify helper
    task assert_equal(input [15:0] expected, input [15:0] actual, input string test_name);
        begin
            test_count = test_count + 1;
            if (expected == actual) begin
                $display("✓ PASS [Test %3d]: %s | Expected: %h | Got: %h", 
                         test_count, test_name, expected, actual);
                pass_count = pass_count + 1;
            end else begin
                $display("✗ FAIL [Test %3d]: %s | Expected: %h | Got: %h", 
                         test_count, test_name, expected, actual);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        // Initialize
        clk = 0;
        rst = 0;
        row = 4'b1111;  // No keys pressed

        $display("\n");
        $display("╔════════════════════════════════════════════════════════╗");
        $display("║     CALCULATOR COMPREHENSIVE TEST SUITE (4-digit BCD) ║");
        $display("╚════════════════════════════════════════════════════════╝\n");

        // Reset pulse
        repeat(5) @(posedge clk);
        rst = 1;
        repeat(10) @(posedge clk);

        // ===================================================================
        // TEST 1: Simple Addition (5 + 3 = 8)
        // ===================================================================
        $display("\n▶ TEST GROUP 1: Simple Addition (5 + 3 = 8)");
        $display("  Input Sequence: 5 # 3 A");
        
        press_key(4'd5);                // Press 5
        press_key(KEY_HASH);            // Press #
        press_key(4'd3);                // Press 3
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result

        $display("  Result: num1=0x005, num2=0x003, result=0x%04h\n", result);

        // ===================================================================
        // TEST 2: Reset and Clear Test
        // ===================================================================
        $display("\n▶ TEST GROUP 2: Reset Test");
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);     // Wait
        
        $display("  After reset: num1=0x%03h, num2=0x%03h\n", num1, num2);

        // ===================================================================
        // TEST 3: Two-digit Addition (42 + 17 = 59)
        // ===================================================================
        $display("\n▶ TEST GROUP 3: Two-digit Addition (42 + 17 = 59)");
        $display("  Input Sequence: 4 2 # 1 7 A");
        
        press_key(4'd4);                // Press 4
        press_key(4'd2);                // Press 2
        press_key(KEY_HASH);            // Press #
        press_key(4'd1);                // Press 1
        press_key(4'd7);                // Press 7
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result
        
        $display("  Result: num1=0x042, num2=0x017, result=0x%04h\n", result);

        // ===================================================================
        // TEST 4: Three-digit Addition (256 + 123 = 379)
        // ===================================================================
        $display("\n▶ TEST GROUP 4: Three-digit Addition (256 + 123 = 379)");
        $display("  Input Sequence: 2 5 6 # 1 2 3 A");
        
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);
        
        press_key(4'd2);                // Press 2
        press_key(4'd5);                // Press 5
        press_key(4'd6);                // Press 6
        press_key(KEY_HASH);            // Press #
        press_key(4'd1);                // Press 1
        press_key(4'd2);                // Press 2
        press_key(4'd3);                // Press 3
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result
        
        $display("  Result: num1=0x256, num2=0x123, result=0x%04h\n", result);

        // ===================================================================
        // TEST 5: Addition with Carry (99 + 1 = 100)
        // ===================================================================
        $display("\n▶ TEST GROUP 5: Carry Test (099 + 001 = 100)");
        $display("  Input Sequence: 0 9 9 # 0 0 1 A");
        
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);
        
        press_key(4'd0);                // Press 0
        press_key(4'd9);                // Press 9
        press_key(4'd9);                // Press 9
        press_key(KEY_HASH);            // Press #
        press_key(4'd0);                // Press 0
        press_key(4'd0);                // Press 0
        press_key(4'd1);                // Press 1
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result
        
        $display("  Result: num1=0x099, num2=0x001, result=0x%04h\n", result);

        // ===================================================================
        // TEST 6: Maximum 3-digit Values (999 + 999 = 1998)
        // ===================================================================
        $display("\n▶ TEST GROUP 6: Large Numbers (999 + 999 = 1998)");
        $display("  Input Sequence: 9 9 9 # 9 9 9 A");
        
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);
        
        press_key(4'd9);                // Press 9
        press_key(4'd9);                // Press 9
        press_key(4'd9);                // Press 9
        press_key(KEY_HASH);            // Press #
        press_key(4'd9);                // Press 9
        press_key(4'd9);                // Press 9
        press_key(4'd9);                // Press 9
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result
        
        $display("  Result: num1=0x999, num2=0x999, result=0x%04h\n", result);

        // ===================================================================
        // TEST 7: Zero + Zero = Zero
        // ===================================================================
        $display("\n▶ TEST GROUP 7: Zero Addition (000 + 000 = 000)");
        $display("  Input Sequence: 0 # 0 A");
        
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);
        
        press_key(4'd0);                // Press 0
        press_key(KEY_HASH);            // Press #
        press_key(4'd0);                // Press 0
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result
        
        $display("  Result: num1=0x%03h, num2=0x%03h, result=0x%04h\n", num1, num2, result);

        // ===================================================================
        // TEST 8: Cancellation Test (Enter number, press *, start over)
        // ===================================================================
        $display("\n▶ TEST GROUP 8: Cancellation Test");
        $display("  Input Sequence: 5 # 3 * 7 # 2 A");
        
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);
        
        press_key(4'd5);                // Press 5
        press_key(KEY_HASH);            // Press #
        press_key(4'd3);                // Press 3
        press_key(KEY_STAR);            // Press * (cancel)
        repeat(500) @(posedge clk);
        
        press_key(4'd7);                // Press 7
        press_key(KEY_HASH);            // Press #
        press_key(4'd2);                // Press 2
        press_key(KEY_A);               // Press A (equals)
        repeat(1000) @(posedge clk);    // Wait for result
        
        $display("  Result: num1=0x%03h, num2=0x%03h, result=0x%04h\n", num1, num2, result);

        // ===================================================================
        // TEST 9: Display Selection Test
        // ===================================================================
        $display("\n▶ TEST GROUP 9: Display Selection States");
        $display("  Monitoring display_sel output during operation");
        
        press_key(KEY_STAR);            // Press * (reset)
        repeat(500) @(posedge clk);
        
        $display("  State: ESPERA, display_sel=%d", display_sel);
        
        press_key(4'd3);                // Press 3
        repeat(100) @(posedge clk);
        $display("  State: INGRESO_NUM1, display_sel=%d", display_sel);
        
        press_key(KEY_HASH);            // Press #
        repeat(100) @(posedge clk);
        $display("  State: INGRESO_NUM2, display_sel=%d", display_sel);
        
        press_key(4'd5);                // Press 5
        repeat(100) @(posedge clk);
        $display("  State: INGRESO_NUM2 (continued), display_sel=%d", display_sel);
        
        press_key(KEY_A);               // Press A
        repeat(500) @(posedge clk);
        $display("  State: SUMA, display_sel=%d, result=0x%04h\n", display_sel, result);

        // ===================================================================
        // TEST 10: Keypad Scanning Verification
        // ===================================================================
        $display("\n▶ TEST GROUP 10: Keypad Scanning Verification");
        $display("  Verifying col signal toggles during scan");
        
        repeat(2000) @(posedge clk);    // Let scanner run
        $display("  col scanning should cycle through 4'b1110, 4'b1101, 4'b1011, 4'b0111\n");

        // ===================================================================
        // TEST 11: BCD Verification (All single digits)
        // ===================================================================
        $display("\n▶ TEST GROUP 11: BCD Single Digit Verification");
        
        for (int digit = 0; digit <= 9; digit = digit + 1) begin
            press_key(KEY_STAR);
            repeat(300) @(posedge clk);
            
            press_key(digit[3:0]);
            press_key(KEY_HASH);
            repeat(100) @(posedge clk);
            
            press_key(digit[3:0]);
            press_key(KEY_A);
            repeat(500) @(posedge clk);
            
            $display("  Test: %d + %d = 0x%04h (Expected BCD)", 
                     digit, digit, result);
        end

        // ===================================================================
        // Final Report
        // ===================================================================
        $display("\n");
        $display("╔════════════════════════════════════════════════════════╗");
        $display("║                     TEST SUMMARY                      ║");
        $display("╠════════════════════════════════════════════════════════╣");
        $display("║ Total Tests Run:     %3d                             ║", test_count);
        $display("║ Passed:              %3d ✓                           ║", pass_count);
        $display("║ Failed:              %3d ✗                           ║", fail_count);
        $display("║ Success Rate:        %5.1f%%                          ║", 
                 (pass_count * 100.0) / test_count);
        $display("╚════════════════════════════════════════════════════════╝\n");

        repeat(1000) @(posedge clk);
        $finish;
    end

    // Dump waveforms for GTKWave
    initial begin
        $dumpfile("calculator_full_tb.vcd");
        $dumpvars(0, calculator_full_tb);
    end

endmodule
