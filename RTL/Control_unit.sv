`timescale 1ns / 1ps
module Control_unit(
    input wire [5:0] opcode,
    output reg [12:0] control_words 
    );

// control words: | RegDst | Jump | Branch(2bit) | MemRead | MemtoReg | ALuop(3bit) | MemWrite | AluSrc | RegWrite | SignZero
// branch[1] is branch, branch[0] = 1 : beq else bne

always @(*) begin
//    if (~rst_n) begin
//        control_words = 13'h0000;
//    end
//    else begin
        case(opcode)
            6'h01: control_words = {1'b1, 1'b0, 2'b00, 1'b0, 1'b0, 3'd2, 1'b0, 1'b0, 1'b1, 1'bx}; // R-type
            6'h08: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd0, 1'b0, 1'b1, 1'b1, 1'b0}; // addi
            6'h09: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd3, 1'b0, 1'b1, 1'b1, 1'b1}; // addiu
            6'h0c: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd4, 1'b0, 1'b1, 1'b1, 1'b0}; // andi
            6'h0d: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd5, 1'b0, 1'b1, 1'b1, 1'b0}; // ori
            6'h0a: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd6, 1'b0, 1'b1, 1'b1, 1'b0}; // slti
            6'h0b: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd7, 1'b0, 1'b1, 1'b1, 1'b1}; // sltiu
            6'h23: control_words = {1'b0, 1'b0, 2'b00, 1'b1, 1'b1, 3'd0, 1'b0, 1'b1, 1'b1, 1'b0}; // lw
            6'h2b: control_words = {1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 3'd0, 1'b1, 1'b1, 1'b0, 1'b0}; // sw
            6'h04: control_words = {1'b0, 1'b0, 2'b11, 1'b0, 1'b0, 3'd1, 1'b0, 1'b0, 1'b0, 1'b0}; // beq (branch[0] = 1)
            6'h05: control_words = {1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 3'd1, 1'b0, 1'b0, 1'b0, 1'b0}; // bne (branch[0] = 0)
            6'h02: control_words = {1'bx, 1'b1, 2'b00, 1'b0, 1'b0, 3'bxxx, 1'b0, 1'b0, 1'b0, 1'bx}; // jump
            default: control_words = 13'b0; // Default case
        endcase
//    end
end



endmodule