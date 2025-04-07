`timescale 1ns / 1ps


module Instruction_Mem(
input wire rst_n,
input wire enable,
input wire [31:0] PC,
output wire [31:0] Instruction
);

reg [7:0] memory [0:2047];
reg [31:0] instr_data;

//wire enable_buf;
//assign #20 enable_buf = enable;

always @(*) begin
    if (~rst_n) begin 
        memory <= '{default: '0};
        instr_data <= 32'h0000;
    end
    else if (enable) begin
        instr_data <= {memory[PC],memory[PC+1],memory[PC+2],memory[PC+3]};
    end
end

assign Instruction = instr_data;

endmodule
