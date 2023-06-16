// Binary Counter
// Count up to 2^WIDTH
module BIN_CNT #(
    parameter WIDTH = 3
) (
    input clk,
    input rstn,
    output reg [WIDTH-1:0] cnt
);

  always @(negedge rstn or posedge clk) begin
    if (~rstn) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
    end
  end

endmodule

// Count up to MAX
module CNT #(
    parameter MAX = 10
) (
    input clk,
    input rstn,
    output reg [clog2(MAX)-1:0] cnt
);

  always @(negedge rstn or posedge clk) begin
    if (~rstn) begin
      cnt <= 0;
    end else if (cnt == MAX - 1) begin
      cnt <= 0;
    end else begin
      cnt <= cnt + 1;
    end
  end

endmodule
