module counter (
    input wire clk,
    input wire rst,
    input wire enable,
    output reg done
);

    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else if (enable) begin
            if (count == 3)
                count <= 0;
            else
                count <= count + 1;
        end
    end

    always @(*) begin
        done = (count == 3);
    end

endmodule
