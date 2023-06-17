module POR #(
    parameter POR_CLK = 8
) (
    input  logic clk,
    output logic rstn
);
  logic [POR_CLK-1:0] rst_cnt = 0;
  assign rstn = &rst_cnt;
  always @(posedge clk) rst_cnt <= rst_cnt + !rstn;
endmodule
