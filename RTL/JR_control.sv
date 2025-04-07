`timescale 1ns / 1ps


module JR_control(
input wire [2:0] ALUOp,
input wire [5:0] funct,
output wire JR
    );

assign JR = (ALUOp == 3'h2 && funct == 6'h08) ? 1'b1 : 1'b0;
endmodule
