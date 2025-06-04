`timescale 1ns / 1ps

module tb_serial_adder;

    reg clk;
    reg rst;
    reg start;
    reg [3:0] in_a, in_b;
    wire [3:0] sum;
    wire carry_out;
    wire done;

    // DUT
    serial_adder_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .in_a(in_a),
        .in_b(in_b),
        .sum(sum),
        .carry_out(carry_out),
        .done(done)
    );

    // Clock: 10ns period (100MHz)
    always #5 clk = ~clk;

    initial begin
        $display("Inicio de testbench para elserial adder");
        $monitor("T=%0t | A=%b, B=%b | SUM=%b | CARRY=%b | DONE=%b", $time, in_a, in_b, sum, carry_out, done);

        // Inicialización
        clk = 0;
        rst = 1;
        start = 0;
        in_a = 0;
        in_b = 0;

        #20;
        rst = 0;

        // Primera prueba: 3 + 5 = 8
        in_a = 4'b0011;
        in_b = 4'b0101;
        start = 1;
        #10;
        start = 0;

        wait(done);
        #10;

        // Segunda prueba: 7 + 9 = 16 (carry_out = 1)
        rst = 1; #10; rst = 0;
        in_a = 4'b0111;
        in_b = 4'b1001;
        start = 1; #10; start = 0;
        wait(done);
        #10;

        // Tercera prueba: 0 + 0 = 0
        rst = 1; #10; rst = 0;
        in_a = 4'b0000;
        in_b = 4'b0000;
        start = 1; #10; start = 0;
        wait(done);
        #10;

        // Fin de simulación
        $display("Fin de pruebas.");
        $stop;
    end
endmodule
