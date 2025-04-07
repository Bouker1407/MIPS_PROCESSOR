`timescale 1ns / 1ps


module IF_buffer(
input wire clk,
input wire rst_n,
input wire enable,
input wire [31:0] out_pc_cal,
input wire IF_flush_buf,
output reg [31:0] PC_in,
output reg IF_flush
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        PC_in <= 32'h0000;
        IF_flush <= 1'b0;
    end
    else if (enable) begin
        PC_in <= out_pc_cal;
        IF_flush <= IF_flush_buf;
    end
end

//assign IF_flush = IF_flush_buf;

endmodule
