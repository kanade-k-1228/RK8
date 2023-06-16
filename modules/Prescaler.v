module Prescaler #(
    parameter N_DIV = 8
) (
    input  wire clk_in,
    output wire clk_out
);

  reg [N_DIV-1:0] cnt = 0;

  assign clk_out = cnt[N_DIV-1];

  always @(posedge clk_in) cnt <= cnt + 1;

endmodule
