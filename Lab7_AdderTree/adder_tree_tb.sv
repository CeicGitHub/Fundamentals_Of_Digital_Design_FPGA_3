`timescale 1ns / 1ps

module adder_tree_tb;

    parameter DATA_WIDTH = 32;
    parameter TREE_INPUTS = 8;

    bit clk;

    logic [DATA_WIDTH-1:0] data_a [TREE_INPUTS];
    logic [DATA_WIDTH-1:0] data_b [TREE_INPUTS];
    logic [DATA_WIDTH-1:0] data_out;

    localparam STAGES = $clog2(TREE_INPUTS) + 1;

    // DUT
    adder_tree #(
        .DATA_WIDTH(DATA_WIDTH),
        .TREE_INPUTS(TREE_INPUTS)
    ) dut (
        .clk(clk),
        .data_a(data_a),
        .data_b(data_b),
        .data_out(data_out)
    );

    // Clock
    always #5 clk = ~clk;

    //TOFIXME declare logics 32bits
    logic [31:0] result;
    logic [31:0] val_a, val_b;
	 integer n;

    /*integer result;
    integer val_a, val_b;
    integer n;*/

    initial begin
        clk = 0;

        repeat(50) begin
            @(negedge clk);
            result = 0;

            //Aqui se generan los datos aleatorios
            for (n = 0; n < TREE_INPUTS; n = n + 1) begin
                val_a = $random;
                val_b = $random;
                data_a[n] = val_a;
                data_b[n] = val_b;
                result = result + val_a + val_b;
            end

            //Aqui espera la propagacion completa (STAGES + 2 ciclos)
            repeat (STAGES + 2) @(negedge clk);

            //TOFIXME change to "unsigned"
            // Mostrar y verificar
            $display("Iteration %0t ns -> data_out = %0d | expected = %0d", $time, data_out, result);
            if (data_out !== result) begin
                $display("ERROR: Result is incorrect.");
                $stop;
            end
        end
		  
		  //show this if the iterations were correct.
        $display("All the iterations were passed.");
        $finish;
    end

endmodule

