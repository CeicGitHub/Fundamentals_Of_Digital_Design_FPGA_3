module adder_tree #(
    parameter DATA_WIDTH = 32,
    parameter TREE_INPUTS = 8  // Debe ser una potencia de 2: 2, 4, 8, 16, ...
)(
    input  logic clk,
    input  logic [DATA_WIDTH-1:0] data_a [TREE_INPUTS],
    input  logic [DATA_WIDTH-1:0] data_b [TREE_INPUTS],
    output logic [DATA_WIDTH-1:0] data_out
);

    // Primer paso: sumar A + B
    logic [DATA_WIDTH-1:0] stage0 [TREE_INPUTS];

    genvar i;
    generate
        for (i = 0; i < TREE_INPUTS; i = i + 1) begin : gen_sum_ab
            always_ff @(posedge clk)
                stage0[i] <= data_a[i] + data_b[i];
        end
    endgenerate

    // Definir cuantas etapas se requieren
    localparam STAGES = $clog2(TREE_INPUTS);

    // Definir todas las etapas intermedias
    logic [DATA_WIDTH-1:0] stage [0:STAGES][TREE_INPUTS-1:0];

    // Inicializar stage[0] con stage0
    generate
        for (i = 0; i < TREE_INPUTS; i = i + 1) begin : gen_stage0_copy
            always_ff @(posedge clk)
                stage[0][i] <= stage0[i];
        end
    endgenerate

    genvar s, j;
    generate
        for (s = 1; s <= STAGES; s = s + 1) begin : stage_loop
            for (j = 0; j < (TREE_INPUTS >> s); j = j + 1) begin : sum_loop
                always_ff @(posedge clk)
                    stage[s][j] <= stage[s-1][2*j] + stage[s-1][2*j+1];
            end
        end
    endgenerate

    // Salida final del arbol
    always_ff @(posedge clk)
        data_out <= stage[STAGES][0];

endmodule

