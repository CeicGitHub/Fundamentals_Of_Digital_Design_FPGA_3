module bin_to_bcd (
    input [13:0] bin,
    output reg [3:0] bcd_thousands,
    output reg [3:0] bcd_hundreds,
    output reg [3:0] bcd_tens,
    output reg [3:0] bcd_units
);

    integer i;
    reg [29:0] shift;  // ¡CORREGIDO de 27:0 a 29:0!

    always @(*) begin
        // Inicialización
        shift = 0;
        shift[13:0] = bin;

        // Algoritmo Double Dabble
        for (i = 0; i < 14; i = i + 1) begin
            if (shift[17:14] >= 5)
                shift[17:14] = shift[17:14] + 3;
            if (shift[21:18] >= 5)
                shift[21:18] = shift[21:18] + 3;
            if (shift[25:22] >= 5)
                shift[25:22] = shift[25:22] + 3;
            if (shift[29:26] >= 5)
                shift[29:26] = shift[29:26] + 3;

            shift = shift << 1;
        end

        bcd_thousands = shift[29:26];
        bcd_hundreds  = shift[25:22];
        bcd_tens      = shift[21:18];
        bcd_units     = shift[17:14];
    end

endmodule

