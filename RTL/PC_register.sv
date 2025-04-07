`timescale 1ns / 1ps


module PC_register(
input wire clk,
input wire rst_n,
input wire PC_write_en,
input wire [31:0] PC_in,
output reg [31:0] PC
    );
    
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        PC <= 32'h0000;
    end
    else if (PC_write_en) begin
        PC <= PC_in;
    end
end

endmodule
