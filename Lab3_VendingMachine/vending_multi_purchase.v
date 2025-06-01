module vending_multi_purchase (
    input wire clk,
    input wire rst,                // SW0

    input wire coin_btn,          // KEY1
    input wire cancel_btn,        // KEY2
    input wire dispense_btn,      // KEY3

    input wire [1:0] sel_product, // SW17 y SW16
    input wire product_dispensed_sw, // SW1

    output reg [6:0] display_credit, // HEX0
    output reg [6:0] display_change, // HEX1
    output reg [6:0] display_price,  // HEX2
    output reg motor_led,            // LEDG8
    output reg [1:0] state_leds      // LEDG0, LEDG1
);

    reg [3:0] coin_count = 0;
    reg [3:0] change = 0;
    reg [3:0] product_price = 0;

    reg coin_btn_prev = 0;
    reg cancel_btn_prev = 0;
    reg dispense_btn_prev = 0;
    reg motor_active = 0;

    // ==== Funciones ====

    function [6:0] to7seg;
        input [3:0] value;
        begin
            case (value)
                4'd0: to7seg = 7'b1000000;
                4'd1: to7seg = 7'b1111001;
                4'd2: to7seg = 7'b0100100;
                4'd3: to7seg = 7'b0110000;
                4'd4: to7seg = 7'b0011001;
                4'd5: to7seg = 7'b0010010;
                4'd6: to7seg = 7'b0000010;
                4'd7: to7seg = 7'b1111000;
                4'd8: to7seg = 7'b0000000;
                4'd9: to7seg = 7'b0010000;
                default: to7seg = 7'b1111111;
            endcase
        end
    endfunction

    function [3:0] get_price;
        input [1:0] sel;
        begin
            case (sel)
                2'b00: get_price = 4;
                2'b01: get_price = 9;
                2'b10: get_price = 2;
                2'b11: get_price = 7;
                default: get_price = 0;
            endcase
        end
    endfunction

    // ==== Lógica principal ====

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            coin_count <= 0;
            change <= 0;
            motor_active <= 0;
        end else begin
            // Detectar flancos de bajada
            coin_btn_prev <= coin_btn;
            cancel_btn_prev <= cancel_btn;
            dispense_btn_prev <= dispense_btn;

            // Insertar moneda
            if (coin_btn_prev && ~coin_btn) begin
                if (coin_count < 9)
                    coin_count <= coin_count + 1;
            end

            // Obtener precio del producto actual
            product_price <= get_price(sel_product);

            // Comprar producto si alcanza
            if (dispense_btn_prev && ~dispense_btn) begin
                if (coin_count >= product_price) begin
                    motor_active <= 1;
                    coin_count <= coin_count - product_price;
                    change <= 0;
                end
            end

            // Producto entregado → apagar motor
            if (motor_active && product_dispensed_sw)
                motor_active <= 0;

            // Cancelar → devolver todo el crédito como cambio
            if (cancel_btn_prev && ~cancel_btn) begin
                change <= coin_count;
                coin_count <= 0;
                motor_active <= 0;
            end
        end
    end

    // ==== Salidas ====

    always @(*) begin
        display_credit = to7seg(coin_count);
        display_change = to7seg(change);
        display_price  = to7seg(product_price); // mostrar precio actual en HEX2
        motor_led = motor_active;
        state_leds = sel_product;
    end

endmodule


