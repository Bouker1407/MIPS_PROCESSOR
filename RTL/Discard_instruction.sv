`timescale 1ns / 1ps


module Discard_instruction (
input wire Jump,
input wire branch_control,
input wire JR,
output wire IF_flush_buf,
output wire ID_flush
    );
    
assign IF_flush_buf = Jump | branch_control | JR;

assign ID_flush = branch_control | JR;
endmodule
