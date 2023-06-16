module SPI_ROM_Dual #(
    parameter SPI_MODE = 0,
    parameter CLK_DIV  = 4
)(
    // Control Signals,
    input rst,
    input clk,

    // TX (MOSI) Signals
    input      [7:0] tx_data,  // Byte to transmit on MOSI
    input            tx_valid, // Data Valid Pulse with i_TX_Byte
    output reg       tx_ready, // Transmit Ready for next byte

    // RX (MISO) Signals
    output reg       rx_valid, // Data Valid pulse (1 clock cycle)
    output reg [7:0] rx_data,  // Byte received on MISO

    // SPI Interface
    output reg scl,
    output     sio_io,
    output     tx,
    input      rx_1,
    input      rx_0
)



endmodule
