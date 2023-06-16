///////////////////////////////////////////////////////////////////////////////////////////////////
// SPI_ROM ////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
//               _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   _   // 
//  clk        :  |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_ //
//                  :                               :                               :   :        //
//  addr       :  0x012 | - - - - - - - - - - - - - : - - - - - - - - - - - - - - - : - : - - -  //
//                 _:___                            :                               :   :        // 
//  addr_valid : _| :   |___________________________:_______________________________:___:_______ //
//               ___^ pos clk & valid -> send       :                               :   ;_______ //
//  addr_ready :    |_______________________________:_______________________________:___|        //
//                  :                               :                               :   ;        //
//  mode       :    | sending                       | receiving                     |end| waiting//
//                  :                               :                               :   :        //
//  count      :  - | 0 | 1 | 2 | 3 | 4 | : |62 |63 | 0 | 1 | 2 | 3 | 4 | : |62 |63 |   ;        //
//                  :                               :                               :___:        //
//  data_valid : ___:_______________________________:_______________________________|   |_______ //
//                  :                               :                               :   :        //
//  data       :  PREV_DATA - - - - - - - - - - - - : - | - - - - - - - - - - - | 0x0123_4567    //
//                  :    ___     ___     ___     ___:    ___     ___     ___     ___:   :        //
//  SCL        : ___:___|   |___|   |___|   |___|   |___|   |___|   |___|   |___|   |___:_______ //
//                  :                               :                               :   :        //
//  MOSI       :  - | [31]  | [30]  |   :   |  [0]  |                               |   :        //
//                  :                               :                               :   :        //
//  MISO       :    :                               : [31]  | [30]  |   :   |  [0]  |   :        //
//            [R]  [A] [B] [C]                     [D] [E] [F]                     [G] [H]       //
///////////////////////////////////////////////////////////////////////////////////////////////////

module SPI_ROM (
    // Control Signals,
    input rstn,
    input clk,

    // TX (MOSI) Signals
    input      [24:0] addr,
    input             addr_valid,
    output            addr_ready,

    // RX (MISO) Signals
    output reg [31:0] data, // RX Shift Registor
    output reg        data_valid,
    
    // SPI Interface
    output reg scl,
    output reg mosi
    input      miso,
);

localparam [7:0] command = 8'h0B;

reg mode; // 00:waiting, 10:sending, 11:receiving, 01:end
reg [ 5:0] count;
reg [31:0] tx_data; // TX Shift Registor
reg [31:0] data; 

assign addr_ready = ~|mode;

always @(negedge rstn or posedge clk) begin
    if(~rstn) begin
        // [R] goto Waiting mode
        mode       <= 2'b00;
        data       <= 0;
        data_valid <= 0;
        scl        <= 0;
        mosi       <= 0;
        count      <= 0;
        tx_data    <= 0;
        data    <= 0;
    end else begin
    casez(mode)
        // Waiting
        2'b00: begin
            if(addr_valid) begin
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
            case(count[0])
            0: // [B] continue MOSI
                count <= count + 1;
                scl   <= 1;
            1: // [C] change MOSI
                count <= count + 1;
                scl   <= 0;
                mosi    <= tx_data[31];
                tx_data <= tx_data << 1;
            endcase 

            if(&count) begin
                // [D] goto Receiving mode
                mode <= 2'b11;
                count <= 0;
                scl   <= 0;
                mosi  <= 0;
            end
        end

        // Receiving
        2'b11: begin
            case(count[0])
            0: // [E] Read MISO
                count <= count + 1;
                scl   <= 0;
                data <= {miso, data[31:1]};
            1: // [F] continue
                count <= count + 1;
                scl   <= 1;
            endcase

            if(&count) begin
                // [G] goto Receiving mode
                mode       <= 2'b11;
                scl        <= 0;
                data_valid <= 1;
            end
        end

        2'b01: begin
            // [H] goto Waiting mode
            mode <= 2'b00;

        end

        endcase
    end
end

endmodule
