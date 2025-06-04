module control_fsm (
    input wire clk,
    input wire rst,
    input wire start,
    input wire count_done,
    output reg load_inputs,
    output reg load_out,
    output reg shift,
    output reg count_enable,
    output reg done
);

    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        LOAD  = 2'b01,
        SHIFT = 2'b10,
        DONE  = 2'b11
    } state_t;

    state_t current_state, next_state;

    // REGISTRO DE ESTADO
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // TRANSICIONES
    always @(*) begin
        case (current_state)
            IDLE:
                next_state = (start) ? LOAD : IDLE;
            LOAD:
                next_state = SHIFT;
            SHIFT:
                next_state = (count_done) ? DONE : SHIFT;
            DONE:
                next_state = (!start) ? IDLE : DONE;
            default:
                next_state = IDLE;
        endcase
    end

    // SALIDAS COMBINACIONALES
    always @(*) begin
        load_inputs  = 0;
        load_out     = 0;
        shift        = 0;
        count_enable = 0;

        case (current_state)
            LOAD: begin
                load_inputs = 1;
                load_out    = 1;
            end
            SHIFT: begin
                shift        = 1;
                count_enable = 1;
            end
        endcase
    end

// REGISTRO DE DONE ACTIVO MIENTRAS START ESTÉ PRESIONADO
always @(posedge clk or posedge rst) begin
    if (rst)
        done <= 0;
    else if (current_state == DONE && start) // activo mientras mantienes presionado start
        done <= 1;
    else
        done <= 0;
end


endmodule
