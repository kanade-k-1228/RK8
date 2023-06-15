module hardware (
    input clk,
    output user_led,
    output pin_13
);

wire rstn;

// Reset
POR #(
    .POR_CLK(8)
) por (
    .clk  (clk ),
    .rstn (rstn)
);
assign pin_13 = !rstn;

// Blink after Reset
wire clk_slow;
Prescaler #(
    .N_DIV(24)
) led_prescaler (
    .clk_in  (clk     ),
    .clk_out (clk_slow)
);
assign user_led = clk_slow & rstn;

endmodule
