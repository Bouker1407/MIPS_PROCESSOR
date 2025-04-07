`timescale 1ns / 1ps
module Adder (
input wire [31:0] in1,         
input wire [31:0] in2,           
output wire [31:0] adder_result    
);
 
//assign adder_overflow = (~adder_select) && (in1[31] == in2[31]) && (adder_result[31] != in1[31]);
assign adder_result = in1 + in2;


endmodule