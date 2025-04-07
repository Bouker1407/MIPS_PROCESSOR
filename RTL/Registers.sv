`timescale 1ns / 1ps

module Registers(
input clk,
input rst_n,
input wire RegWrite,
input wire [4:0] read_register1,
input wire [4:0] read_register2,
input wire [4:0] write_register,
input wire [31:0] write_data_register,
output reg [31:0] read_data1,
output reg [31:0] read_data2
    );

reg [31:0] RF [0:31]; //Registers space


always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        RF <= '{default: '0};
        read_data1 <= 0;
        read_data2 <= 0;
    end
    else begin
        if (RegWrite && write_register != 0 ) begin
            RF[write_register] <= write_data_register;
        end
        else begin
            read_data1 <= (read_register1 != 0) ? RF[read_register1] : 32'h0000;
            read_data2 <= (read_register2 != 0) ? RF[read_register2] : 32'h0000;
        end
    end
end




endmodule
