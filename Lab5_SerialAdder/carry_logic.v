module carry_logic (
    input wire clk,
    input wire rst,
    input wire load,
    input wire carry_in,
    output reg carry_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            carry_out <= 0;
        else if (load)
            carry_out <= carry_in;
    end
endmodule
