////////////////////////////////////////////////////////////////////////////////////////
// SPI_ROM /////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////
//               _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _    // 
//  clk        :  |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_  //
//                  :                       :                       :       :         //
//  addr       :  0x012 | - - - - - - - - - : - - - - - - - - - - - : - - - : - - - - //
//                 _:___                    :                       :       :         // 
//  addr_valid : _| :   |___________________:_______________________:_______:________ //
//               ___:                       :                       :       ;________ //
//  addr_ready :    |_______________________:_______________________:_______|         //
//                  :                       :                       :       ;         //
//  mode       :    | sending               | receiving             | end   | waiting //
//                  :                       :                       :       :         //
//  count      :  - | 0 | 1 | 2 | : |62 |63 | 0 | 1 | 2 | : |62 |63 |       ;         //
//                  :                       :                       :_______:         //
//  data_valid : ___:_______________________:_______________________|       |________ //
//                  :                       :                       :       :         //
//  data       :  PREV_DATA - - - - - - - - : - | - - - | - - - | 0x0123_4567         //
//                  :    ___     ___     ___:    ___     ___     ___:       :         //
//  SCL        : ___:___|   |___|   |___|   |___|   |___|   |___|   |_______:________ //
//                  :                       :                       :       :         //
//  MOSI       :  - | [31]  |   :   |  [0]  |                       |       :         //
//                  :                       :                       :       :         //
//  MISO       :    :                       : [31]  |   :   |  [0]  |       :         //
//            [R]  [A] [B] [C]             [D] [E] [F]             [G]     [H]        //
////////////////////////////////////////////////////////////////////////////////////////

module SPI_ROM (
    // Control Signals,
    input logic rstn,
    input logic clk,

    // TX (MOSI) Signals
    input  logic [23:0] addr,
    input  logic        addr_valid,
    output logic        addr_ready,

    // RX (MISO) Signals
    output logic [31:0] data,       // RX Shift Registor
    output logic        data_valid,

    // SPI Interface
    output logic scl,
    output logic mosi,
    input  logic miso
);

  localparam [7:0] command = 8'h0B;

  logic mode;  // 00:waiting, 10:sending, 11:receiving, 01:end
  logic [5:0] count;
  logic [31:0] tx_data;  // TX Shift Registor
  logic [31:0] data;
  logic valid_cnt;

  assign addr_ready = ~|mode;

  always @(negedge rstn or posedge clk) begin
    if (~rstn) begin
      // [R] goto Waiting mode
      mode       <= 2'b00;
      data       <= 0;
      data_valid <= 0;
      scl        <= 0;
      mosi       <= 0;
      count      <= 0;
      tx_data    <= 0;
      data       <= 0;
    end else begin
      casez (mode)
        // Waiting
        2'b00: begin
          if (addr_valid) begin
            // [A] goto Sending mode
            mode    <= 2'b10;
            count   <= 0;
            scl     <= 0;
            mosi    <= command[7];
            tx_data <= {command, addr};
          end
        end

        // Sending
        2'b10: begin
          case (count[0])
            0: begin  // [B] continue MOSI
              count <= count + 1;
              scl   <= 1;
            end
            1: begin  // [C] change MOSI
              count <= count + 1;
              scl   <= 0;
              mosi    <= tx_data[31];
              tx_data <= tx_data << 1;
            end
          endcase

          if (&count) begin
            // [D] goto Receiving mode
            mode  <= 2'b11;
            count <= 0;
            scl   <= 0;
            mosi  <= 0;
          end
        end

        // Receiving
        2'b11: begin
          case (count[0])
            0: begin  // [E] Read MISO
              count <= count + 1;
              scl   <= 0;
              data  <= {miso, data[31:1]};
            end
            1: begin  // [F] continue
              count <= count + 1;
              scl   <= 1;
            end
          endcase

          if (&count) begin
            // [G] goto Receiving mode
            mode       <= 2'b11;
            scl        <= 0;
            data_valid <= 1;
            valid_cnt  <= 0;
          end
        end

        2'b01: begin
          case (valid_cnt)
            0: begin
              valid_cnt <= 1;
            end
            1: begin  // [H] goto Waiting mode
              mode <= 2'b00;
              data_valid <= 0;
            end
          endcase
        end

      endcase
    end
  end

endmodule
