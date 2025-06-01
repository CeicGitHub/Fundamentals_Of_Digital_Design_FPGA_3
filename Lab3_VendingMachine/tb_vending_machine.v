`timescale 1ns / 1ps

module tb_vending_machine;

    reg clk = 0;
    reg rst = 1;

    reg coin_btn = 0;
    reg cancel_btn = 0;
    reg dispense_btn = 0;
    reg product_dispensed_sw = 0;
    reg [1:0] sel_product = 2'b00;

    wire [6:0] display_credit;
    wire [6:0] display_change;
    wire [6:0] display_price;
    wire motor_led;
    wire [1:0] state_leds;

    // Instanciar el DUT
    vending_multi_purchase uut (
        .clk(clk),
        .rst(rst),
        .coin_btn(coin_btn),
        .cancel_btn(cancel_btn),
        .dispense_btn(dispense_btn),
        .sel_product(sel_product),
        .product_dispensed_sw(product_dispensed_sw),
        .display_credit(display_credit),
        .display_change(display_change),
        .display_price(display_price),
        .motor_led(motor_led),
        .state_leds(state_leds)
    );

    // Reloj
    always #5 clk = ~clk;

    initial begin
        // Mensaje de bienvenida
        $display("\nHola, Bienvenido a Machine'KFC'");
        $display("El precio de los productos es:");
        $display("00: Papas ................ $2");
        $display("01: Combo McChiken ....... $9");
        $display("10: Nieve ................ $4");
        $display("11: Platillo individual .. $7\n");

        // Encabezado de monitoreo
        $display("Tiempo | Credito | Cambio | Motor | Producto");
        $monitor("%5dns |   %b   |   %b   |   %b   |   %b",
                 $time, display_credit, display_change, motor_led, sel_product);

        // Reset
        #20 rst = 0;

        // Insertar $3
        repeat (3) begin
            #10 coin_btn = 1; #10 coin_btn = 0;
        end

        // Seleccionar papas (producto 10, $2)
        #10 sel_product = 2'b10;
        #10 dispense_btn = 1; #10 dispense_btn = 0;
        #10 product_dispensed_sw = 1; #10 product_dispensed_sw = 0;

        // Seleccionar nieve (producto 00, $4), saldo restante: $1
        #10 sel_product = 2'b00;
        #10 dispense_btn = 1; #10 dispense_btn = 0;

        // Insertar $1 más
        #10 coin_btn = 1; #10 coin_btn = 0;

        // Intentar nuevamente
        #10 dispense_btn = 1; #10 dispense_btn = 0;
        #10 product_dispensed_sw = 1; #10 product_dispensed_sw = 0;

        // Cancelar para recibir cambio
        #10 cancel_btn = 1; #10 cancel_btn = 0;

        #50 $finish;
    end

endmodule
