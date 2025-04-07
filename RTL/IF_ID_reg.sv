`timescale 1ns / 1ps

module IF_ID_reg(
input wire clk,
input wire rst_n,
input wire IF_ID_write_en,
input wire [31:0] PC4,
input wire [31:0] Instruction,
input wire IF_flush,
output reg [31:0] ID_PC4,
output reg [31:0] ID_Instruction,
output reg IF_ID_flush
    );
 
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ID_PC4 <= 32'h0000;
        ID_Instruction <= 32'h0000;
        IF_ID_flush <= 1'b0;
    end
    else if (IF_ID_write_en) begin
        ID_PC4 <= PC4;
        ID_Instruction <= Instruction;
        IF_ID_flush <= IF_flush;
    end
end


endmodule
