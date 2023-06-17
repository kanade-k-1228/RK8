module hardware (
    input  logic clk,
    output logic user_led,
    output logic pin_13
);

  // Reset
  logic rstn;
  POR #(
      .POR_CLK(8)
  ) por (
      .clk (clk),
      .rstn(rstn)
  );

  assign pin_13 = !rstn;

  // Blink
  // SOS Pattern
  // [* - * - * - * * * - - - * * * - - - * * * - - - * - * - * -]
  //  0   2   4   6 7 8       121314      181920      24  26  28

  localparam PATTERN_LEN = 30;
  always_comb begin
    case (cnt)
      0, 2, 4, 6, 7, 8, 12, 13, 14, 18, 19, 20, 24, 26, 28: user_led <= 1;
      default: user_led <= 0;
    endcase
  end

  logic clk_slow;
  logic [$clog2(PATTERN_LEN)-1:0] cnt;
  Prescaler #(
      .N(21)
  ) BlinkPrescaler (
      .clk_in (clk),
      .clk_out(clk_slow)
  );
  Counter #(
      .N(PATTERN_LEN)
  ) BlinkCounter (
      .clk (clk_slow),
      .rstn(rstn),
      .cnt (cnt)
  );

endmodule
