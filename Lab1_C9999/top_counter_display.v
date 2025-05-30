module top_counter_display (
    input CLOCK_50,           // MainClock_50MHZ FPGA
    input key_clk,            // KEY[0]
    input rst,
    input en,
    input load,
    input up_down,
    input [13:0] data_in,
    output last,
    output [6:0] seg0, seg1, seg2, seg3
);

    // === Sincronizador y detector de flanco de bajada ===
    reg key_sync_0, key_sync_1;
    always @(posedge CLOCK_50) begin
        key_sync_0 <= key_clk;
        key_sync_1 <= key_sync_0;
    end

    wire clk_pulse = key_sync_1 & ~key_sync_0;

    wire [13:0] q;
    wire [3:0] u, t, h, th;

    counter_9999 counter_inst (
        .clk(clk_pulse),       // +1 when pulse the clokc KEY[0]
        .rst(rst),
        .en(en),
        .load(load),
		  .up_down(up_down),
        .data_in(data_in),
        .last(last),
        .q(q)
    );

    bin_to_bcd bcd_inst (
        .bin(q),
        .bcd_units(u),
        .bcd_tens(t),
        .bcd_hundreds(h),
        .bcd_thousands(th)
    );

    bcd_to_7seg disp0 (.bcd(u),  .seg(seg0));
    bcd_to_7seg disp1 (.bcd(t),  .seg(seg1));
    bcd_to_7seg disp2 (.bcd(h),  .seg(seg2));
    bcd_to_7seg disp3 (.bcd(th), .seg(seg3));

endmodule
