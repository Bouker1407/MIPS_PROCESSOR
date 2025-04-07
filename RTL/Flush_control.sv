`timescale 1ns / 1ps

module Flush_control(
input wire stall_flush,
input wire IF_ID_flush,
input wire ID_flush,
input wire [10:0] control_words_splitted,
output wire [10:0] ID_control_words
    );


    // control words: | RegDst | Jump | Branch(2bit) | MemRead | MemtoReg | ALuop(3bit) | MemWrite | ALUSrc | RegWrite | SignZero
// branch[1] is branch, branch[0] = 1 : beq else bne

wire flush;
assign flush = stall_flush | IF_ID_flush | ID_flush;

assign ID_control_words = (flush) ? 11'h000 : control_words_splitted;

endmodule
