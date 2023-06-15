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


// Power on Reset
module POR #(
    parameter POR_CLK = 8
)(
    input  wire clk,
    output wire rstn
);
reg [POR_CLK-1:0] rst_cnt = 0;
assign rstn = &rst_cnt;
always @(posedge clk) 
    rst_cnt <= rst_cnt + !rstn;
endmodule


// Prescale
module Prescaler #(
    parameter N_DIV = 8
)(
    input wire  clk_in,
    output wire clk_out
);
reg [N_DIV-1:0] cnt = 0;
assign clk_out = cnt[N_DIV-1];
always @(posedge clk_in) 
    cnt <= cnt + 1;
endmodule
