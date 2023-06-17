module hardware (
    input  logic clk,
    output logic user_led,

    output logic pin_1,
    output logic pin_2,
    output logic pin_3,

    input logic pin_4,
    input logic pin_5
);

  // Reset
  logic rstn;
  POR #(
      .POR_CLK(8)
  ) por (
      .clk (clk),
      .rstn(rstn)
  );

  assign pin_13 = user_led;

  logic [23:0] addr = 24'h05_0000 + {pin_4, pin_5, 0, 0};
  logic [31:0] data;

  Parallel_ROM rom (
      .rstn(rstn),
      .clk(clk),
      .addr(addr),
      .data(data),
      .readyn(),
      .scl(pin_1),
      .mosi(pin_2),
      .miso(pin_3)
  );

  //   assign {pin_14, pin_15, pin_16, pin_17, pin_18, pin_19, pin_20, pin_21} = data[7:0];

endmodule
