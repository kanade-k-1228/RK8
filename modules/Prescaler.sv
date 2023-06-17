module Prescaler #(
    parameter N = 8
) (
    input  logic clk_in,
    output logic clk_out
);

  logic [N-1:0] cnt = 0;

  assign clk_out = cnt[N-1];

  always @(posedge clk_in) cnt <= cnt + 1;

endmodule
