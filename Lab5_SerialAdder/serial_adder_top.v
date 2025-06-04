module serial_adder_top (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [3:0] in_a,
    input wire [3:0] in_b,
    output wire [3:0] sum,
    output wire carry_out,
    output wire done
);

    // Señales internas
    wire load_inputs, load_out, shift, count_enable, count_done;
    wire a_lsb, b_lsb;
    wire carry_wire;
    wire sum_bit;

    // FSM de control
    control_fsm ctrl (
        .clk(clk),
        .rst(rst),
        .start(start),
        .count_done(count_done),
        .load_inputs(load_inputs),
        .load_out(load_out),
        .shift(shift),
        .count_enable(count_enable),
        .done(done)
    );

    // Contador
    counter cnt (
        .clk(clk),
        .rst(rst),
        .enable(count_enable),
        .done(count_done)
    );

    // Registro de entrada A
    input_reg reg_a (
        .clk(clk),
        .rst(rst),
        .load(load_inputs),
        .shift(shift),
        .data_in(in_a),
        .lsb_out(a_lsb)
    );

    // Registro de entrada B
    input_reg reg_b (
        .clk(clk),
        .rst(rst),
        .load(load_inputs),
        .shift(shift),
        .data_in(in_b),
        .lsb_out(b_lsb)
    );

    // Sumador de 1 bit
    full_adder adder (
        .a(a_lsb),
        .b(b_lsb),
        .cin(carry_wire),
        .sum(sum_bit),
        .cout(carry_out_temp)
    );

    // Lógica de carry
    carry_logic carry (
        .clk(clk),
        .rst(rst),
        .load(shift),
        .carry_in(carry_out_temp),
        .carry_out(carry_wire)
    );

    // Registro de salida
    output_reg result (
        .clk(clk),
        .rst(rst),
        .load(load_out),
        .shift(shift),
        .sum_bit(sum_bit),
        .sum(sum)
    );

    // Carry final
    assign carry_out = carry_wire;

endmodule




