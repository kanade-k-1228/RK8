// Shift Registor
module PISO #(
    parameter WIDTH = 8
)(
    input clk,
    input rstn,
    input valid,
    input [WIDTH-1:0] parallel_in,
    output serial_out
);

reg [WIDTH-1:0] send_buf;
reg [WIDTH-1:0] send_cnt;

always @(negedge rstn or posedge valid) begin
    if(~rstn) begin
        send_buf <= 0;
        send_cnt <= 0;
    end else if(valid) begin
        
    end
end

always @(posedge valid) begin
    send_buf <= parallel_in;
    send_cnt <= ;
end

endmodule

module SIPO #(
    parameter WIDTH = 8
)(
    input clk,
    input rstn,
    input serial_in,
    output reg [WIDTH-1:0] parallel_out
);

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        rx_data_buf <= 0;
    end else begin
        rx_data_buf <= {rx_data_buf[6:0], miso};
    end
end

endmodule
