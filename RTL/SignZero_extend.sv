`timescale 1ns / 1ps
module SignZero_extend (
input wire SignZero, //0 sign, 1 zero
input wire [15:0] Immediate,
output wire [31:0] Immediate_extended
);
wire [31:0] imm_buf;

assign imm_buf = (SignZero) ? {16'h0000, Immediate} : {{16{Immediate[15]}}, Immediate};

assign  Immediate_extended = imm_buf;
endmodule
