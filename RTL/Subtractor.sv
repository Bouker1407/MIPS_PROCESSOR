`timescale 1ns / 1ps
module Subtractor (
input wire [31:0] in1,         
input wire [31:0] in2,         
input wire sub_select,     
output wire [31:0] sub_result
);

wire [31:0] comp_in2;
assign comp_in2 = (~in2) + 1'b1;
//assign sub_overflow = (~sub_select) && (in1[31] == in2[31]) && (sub_result[31] != in1[31]);
assign sub_result = (sub_select == 1) ? in1 - in2 : in1 + comp_in2;


endmodule