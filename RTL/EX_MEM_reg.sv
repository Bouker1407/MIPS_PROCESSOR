`timescale 1ns / 1ps

module EX_MEM_reg #(clock_delay = 20)(
input wire clk,
input wire rst_n,
input wire EX_MemRead,
input wire EX_MemtoReg,
input wire EX_MemWrite,
input wire EX_RegWrite,
input wire [31:0] ALU_result,
input wire [31:0] EX_write_data_mem,
input wire [4:0] EX_write_register,
output reg MEM_MemRead,
output reg MEM_MemtoReg,
output reg MEM_MemWrite,
output reg MEM_RegWrite,
output reg [31:0] MEM_ALU_result,
output reg [31:0] MEM_write_data_mem,
output reg [4:0] MEM_write_register
);

wire EX_MemRead_buf;
wire EX_MemtoReg_buf;
wire EX_MemWrite_buf;
wire EX_RegWrite_buf;
wire [31:0] EX_write_data_mem_buf;
wire [4:0] EX_write_register_buf;

assign #(clock_delay+1) EX_MemRead_buf = EX_MemRead;
assign #(clock_delay+1) EX_MemtoReg_buf = EX_MemtoReg;
assign #(clock_delay+1) EX_MemWrite_buf = EX_MemWrite;
assign #(clock_delay+1) EX_RegWrite_buf = EX_RegWrite;
assign #(clock_delay+1) EX_write_data_mem_buf = EX_write_data_mem;
assign #(clock_delay+1) EX_write_register_buf = EX_write_register;

    // control words: | MemRead | MemtoReg | MemWrite | RegWrite |
// branch[1] is branch, branch[0] = 1 : beq else bne

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        MEM_MemRead <= 1'b0;
        MEM_MemtoReg <= 1'b0;
        MEM_MemWrite <= 1'b0;
        MEM_RegWrite <= 1'b0;
        MEM_ALU_result <= 32'h0000;
        MEM_write_data_mem <= 32'h0000;
        MEM_write_register <= 5'h00;
    end
    else begin
        MEM_MemRead <= EX_MemRead_buf;
        MEM_MemtoReg <= EX_MemtoReg_buf;
        MEM_MemWrite <= EX_MemWrite_buf;
        MEM_RegWrite <= EX_RegWrite_buf;
        MEM_ALU_result <= ALU_result;
        MEM_write_data_mem <= EX_write_data_mem_buf;
        MEM_write_register <= EX_write_register_buf;
    end
end


endmodule