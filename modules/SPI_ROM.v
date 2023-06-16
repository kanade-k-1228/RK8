// 24 Bit Address
// 32 Bit Data
// 1. Send Command 0x03
// 2. Send Mem Address
// 3. Get Data

module SPI_ROM #(
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
    input      miso,
    output reg mosi
)


endmodule
