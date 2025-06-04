module input_reg (
    input wire clk,
    input wire rst,
    input wire load,
    input wire shift,
    input wire [3:0] data_in,
    output wire lsb_out
);
    reg [3:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst)
            data <= 4'd0;
        else if (load)
            data <= data_in;
        else if (shift)
            data <= {1'b0, data[3:1]}; // desplaza a la derecha
    end

    assign lsb_out = data[0];
endmodule
