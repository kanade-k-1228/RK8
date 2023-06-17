////////////////////////////////////////////////////////////////////////////////////
// Parallel_ROM ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
// アドレスの変化を検出したら、ROMにアクセスして、データを取り出す                //
// readyn = 0 のクロックサイクルは、アドレスとデータに矛盾はない                  //
// リセット直後は、0番地を読みだす。                                              //
//                                                                                //
//                 : Reset                    : Reading                           //
//                 :   _   _   _   _   _  :_  :_   _   _   _   _   _   _   _   _  //
//  clk            :|_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_|   //
//                 :      :               :   :       :               :           //
//  addr           : XXXX :               : | AAAA | XXXX             :           //
//                 :______:_______________:   :_______:_______________:           // 
//  readyn         : Reading              |___| Reading               |_Ready___  //
//                 :______:               :   :_______:               :           //
//  SPI.addr_valid :      |_______________:___|       |_______________:_________  //
//                 :      :               :   :       :               :           //
//  SPI.addr       : 0000 :               :   | AAAA  :               :           //
//                 :      :               :   :       :               :           //
//  SPI.data       :      :       | ROM[0000] :       :        | ROM[AAAA]        //
//                 :      :            ___:___:       :            ___:___        //
//  SPI.data_valid :______:___________|   :   |_______:___________|   :   |_____  //
//                 :      :               :   :       :               :           //
//  data           :      :               | ROM[0000] :               | ROM[AAAA] //
//                 :      :               :   :       :               :           //
//                [R] [A']               [D] [A] ['] [B]             [C]          //
////////////////////////////////////////////////////////////////////////////////////

module Parallel_ROM (
    input logic rstn,
    input logic clk,

    input  logic [23:0] addr,
    output logic [31:0] data,
    output logic        readyn,

    output logic scl,
    output logic mosi,
    input  logic miso
);

  logic spi_addr_valid;
  logic [23:0] spi_addr;
  logic spi_data_valid;
  logic [23:0] spi_data;
  logic [1:0] read_state;  // 0,1: Sending Valid 2: Waiting Valid

  SPI_ROM spi_rom (
      .rstn(rstn),
      .clk(clk),
      .addr(spi_addr),
      .addr_valid(spi_addr_valid),
      .addr_ready(),
      .data(spi_data),
      .data_valid(spi_data_valid),
      .scl(scl),
      .mosi(mosi),
      .miso(miso)
  );

  always @(negedge rstn or posedge clk) begin
    if (~rstn) begin
      // [R] Reset
      readyn <= 0;
      spi_addr_valid <= 0;
      readyn <= 1;
      spi_addr <= 0;
    end else begin
      case (readyn)
        0: begin
          // Ready
          if (addr != spi_addr) begin
            // [A] goto Reading mode
            readyn <= 1;
            spi_addr <= addr;
            spi_addr_valid <= 1;
            read_state <= 0;
            valid_cnt <= 0;
          end
        end
        1: begin
          // Reading
          casez (read_state)
            0: begin
              // [A'] Sending Valid
              read_state <= 1;
            end
            1: begin
              // [B] Waiting Valid
              read_state <= 2;
              spi_addr_valid <= 0;
            end
            2: begin
              if (spi_data_valid) begin
                // [C] Data Received
                readyn <= 0;
                data   <= spi_data;
              end
            end
          endcase
        end
      endcase
    end
  end

endmodule
