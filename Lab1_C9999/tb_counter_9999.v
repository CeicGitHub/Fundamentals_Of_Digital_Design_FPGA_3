`timescale 1ns / 1ps

module tb_top_counter_display();

    reg key_clk;
    reg rst;
    reg en;
    reg load;
    reg up_down;
    reg [13:0] data_in;
    wire last;
    wire [6:0] seg0, seg1, seg2, seg3;

    // Instancia del módulo principal
    top_counter_display uut (
        .key_clk(key_clk),
        .rst(rst),
        .en(en),
        .load(load),
        .up_down(up_down),
        .data_in(data_in),
        .last(last),
        .seg0(seg0),
        .seg1(seg1),
        .seg2(seg2),
        .seg3(seg3)
    );

    // Tarea para simular flanco de bajada del botón
    task clk_pulse;
    begin
        key_clk = 1;
        #5;
        key_clk = 0;  // Flanco de bajada (activo)
        #5;
    end
    endtask

    initial begin
        // Inicialización
        key_clk = 1; // botón "no presionado"
        rst = 1; en = 0; load = 0; up_down = 0; data_in = 0;
        #10;

        // Liberar reset
        rst = 0;
        #10;

        // Cargar valor válido (ej. 20)
        en = 1;
        data_in = 14'd20;
        load = 1;
        clk_pulse();    // Pulso para cargar
        load = 0;

        // Contar hacia arriba
        up_down = 0;
        repeat (5) clk_pulse();

        // Contar hacia abajo
        up_down = 1;
        repeat (5) clk_pulse();

        // Cargar valor inválido (>9999)
        data_in = 14'd12000;
        load = 1;
        clk_pulse();
        load = 0;

        // Contar desde 9999 para probar desbordamiento
        data_in = 14'd9999;
        load = 1;
        clk_pulse();
        load = 0;
        up_down = 0;
        clk_pulse(); // Debería volver a 0

        // Contar hacia abajo desde 0 para underflow
        data_in = 14'd0;
        load = 1;
        clk_pulse();
        load = 0;
        up_down = 1;
        clk_pulse(); // Debería ir a 9999

        // Deshabilitar enable
        en = 0;
        repeat (3) clk_pulse(); // No debería cambiar

        $stop;
    end

endmodule
