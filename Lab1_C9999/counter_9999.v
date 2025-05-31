/*This stage is for test the counter in test-bench section across the
	the main principle in the stage the limit preserv the section "limit"*/
	
module counter_9999 #(
    parameter WIDTH = 14,
    parameter LIMIT = 9999
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire up_down,  // 0 = up, 1 = down
    input wire [WIDTH-1:0] data_in,
    output wire last,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 0;
        end else if (en) begin
            if (load) begin
                if (data_in > LIMIT)
                    q <= 0;
                else
                    q <= data_in;
            end else if (!up_down) begin
                if (q == LIMIT)
                    q <= 0;
                else
                    q <= q + 1;
            end else begin
                if (q == 0)
                    q <= LIMIT;
                else
                    q <= q - 1;
            end
        end
    end

    assign last = (q == LIMIT || q == 0);

endmodule
