module hardware (
    input  logic clk,
    output logic user_led,
    output logic pin_1,
    output logic pin_2,
    output logic pin_3,
    output logic pin_4,
    output logic pin_5,
    output logic pin_6,
    output logic pin_7,
    output logic pin_8,
    input  logic pin_14,
    input  logic pin_15,
    input  logic pin_16,
    input  logic pin_17,
    input  logic pin_18,
    input  logic pin_19,
    input  logic pin_20,
    input  logic pin_21
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

  logic [23:0] addr = 24'h05_0000 + {pin_1, pin_2, pin_3, pin_4, pin_5, pin_6, pin_7, pin_8, 0, 0};
  logic [31:0] data;

  Parallel_ROM rom (
      .rstn(rstn),
      .clk(clk),
      .addr(addr),
      .data(data),
      .readyn(),
      .scl(),
      .mosi(),
      .miso()
  );

endmodule
