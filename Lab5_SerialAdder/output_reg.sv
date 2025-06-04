module output_reg (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire sum_bit,
    output reg [3:0] sum
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            sum <= 4'd0;
        else if (load)
            sum <= 4'd0;
        else if (shift)
            sum <= {sum[2:0], sum_bit}; // desplaza a la izquierda
    end
endmodule
