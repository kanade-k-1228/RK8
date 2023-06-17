// Count up to N
module Counter #(
    parameter N = 10
) (
    input logic clk,
    input logic rstn,
    output logic [WIDTH-1:0] cnt
);

  localparam WIDTH = $clog2(N);

  always @(negedge rstn or posedge clk) begin
    if (~rstn) begin
      cnt <= 0;
    end else if (cnt == (N - 1)) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
    end
  end

endmodule
