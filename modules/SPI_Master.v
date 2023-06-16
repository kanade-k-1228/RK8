module SPI_Master #(
    parameter SPI_MODE = 0
)(
    // Control Signals,
    input rstn,
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
    output reg mosi
    input      miso,
);

///////////////////////////////////////////////
// SPI Mode Setting
///////////////////////////////////////////////
//   | CPOL | CPHA |
// 0 | 0    | 0    |
// 1 | 0    | 1    |
// 2 | 1    | 0    |
// 3 | 1    | 1    |
//
// CPOL: Clock Polarity
//    0:        ___     ___     ___     ___
//        _____|   |___|   |___|   |___|   |_____
//    1:  _____     ___     ___     ___     _____
//             |___|   |___|   |___|   |___|
// 
// CPHA: Clock Phase
//    0:   |   1   |   2   |   3  |:|  8   |
//    1:       |   1   |   2   |   3  |:|  8   |
//

assign CPOL  = (SPI_MODE == 2) | (SPI_MODE == 3);
assign CPHA  = (SPI_MODE == 1) | (SPI_MODE == 3);

wire clk_norm = clk ^ CPOL;

///////////////////////////////////////////////
// Send Data
///////////////////////////////////////////////


///////////////////////////////////////////////
// Receive Data
///////////////////////////////////////////////
reg [7:0] rx_data_buf;
SIPO rx_sr (
    .clk(clk_norm),
    .rstn(rstn),
    .serial_in(miso),
    .parallel_out(rx_data_buf)
);
// Set received data and send valid signal
always @(posedge recev_done) begin
    rx_data <= rx_data_buf;
    rx_valid <= 1'b1;
end

endmodule
