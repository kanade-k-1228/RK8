module hardware (
    input  clk,
    output user_led,
    output pin_13
);

  wire rstn;

  // Reset
  POR #(
      .POR_CLK(8)
  ) por (
      .clk (clk),
      .rstn(rstn)
  );
  assign pin_13 = !rstn;

  // Blink after Reset
  wire clk_blink;
  Prescaler #(
      .N_DIV(24)
  ) led_prescaler (
      .clk_in (clk),
      .clk_out(clk_blink)
  );
  assign user_led = clk_blink & rstn;

  // Read SPI Flash

endmodule


module MEM_Burst (
    input clk,
    input rstn,
    output [7:0] data
);

  BIN_CNT #(
      .WIDTH(24)
  ) cnt (
      .clk (clk),
      .rstn(rstn)
  );

  SPI_ROM #() rom ();

endmodule
