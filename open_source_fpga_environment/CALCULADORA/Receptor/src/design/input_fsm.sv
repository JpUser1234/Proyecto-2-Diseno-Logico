module input_fsm ( 
    input  wire        clk,
    input  wire        rst,
    input  wire        key_valid,
    input  wire [3:0]  key_value,
    output reg  [11:0] num1,
    output reg  [11:0] num2,
    output reg         do_sum,
    output reg  [1:0]  display_sel
);

localparam KEY_HASH = 4'd13;
localparam KEY_A    = 4'd10;
localparam KEY_STAR = 4'd14;

// ================= EDGE DETECTION =================
reg key_valid_d;
wire key_pulse;

always_ff @(posedge clk) begin
    if (!rst)
        key_valid_d <= 0;
    else
        key_valid_d <= key_valid;
end

assign key_pulse = key_valid & ~key_valid_d;

// ================= ESTADOS =================
typedef enum logic [1:0] {
    ESPERA,
    INGRESO_NUM1,
    INGRESO_NUM2,
    SUMA
} state_t;

state_t state, next_state;

// ================= STATE REGISTER =================
always_ff @(posedge clk) begin
    if (!rst)
        state <= ESPERA;
    else
        state <= next_state;
end

// ================= TRANSICIONES =================
always_comb begin
    next_state = state;

    if (key_pulse) begin
        case (state)

            ESPERA:
                if (key_value <= 9)
                    next_state = INGRESO_NUM1;

            INGRESO_NUM1:
                case (key_value)
                    KEY_HASH: next_state = INGRESO_NUM2;
                    KEY_STAR: next_state = ESPERA;
                endcase

            INGRESO_NUM2:
                case (key_value)
                    KEY_A:    next_state = SUMA;
                    KEY_STAR: next_state = ESPERA;
                endcase

            SUMA:
                if (key_value == KEY_STAR)
                    next_state = ESPERA;

        endcase
    end
end

// ================= DATOS =================
always_ff @(posedge clk) begin
    if (!rst) begin
        num1 <= 0;
        num2 <= 0;
        do_sum <= 0;
        display_sel <= 0;
    end else begin
        do_sum <= 0;

        if (key_pulse) begin
            case (state)

                ESPERA: begin
                    display_sel <= 0;
                    if (key_value <= 9)
                        num1 <= {8'd0, key_value};
                end

                INGRESO_NUM1: begin
                    display_sel <= 0;
                    if (key_value <= 9)
                        num1 <= {num1[7:0], key_value};
                end

                INGRESO_NUM2: begin
                    display_sel <= 1;
                    if (key_value <= 9)
                        num2 <= {num2[7:0], key_value};

                    if (key_value == KEY_A)
                        do_sum <= 1;
                end

                SUMA: begin
                    display_sel <= 2;
                end

            endcase
        end
    end
end

endmodule