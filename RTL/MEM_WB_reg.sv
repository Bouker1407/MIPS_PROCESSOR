`timescale 1ns / 1ps
module MEM_WB_reg #(clock_delay = 20) (
input wire clk,
input wire rst_n,
input wire MEM_MemtoReg,
input wire MEM_RegWrite,
input wire [31:0] read_data,
input wire [31:0] MEM_ALU_result,
input wire [4:0] MEM_write_register,
output reg WB_MemtoReg,
output reg WB_RegWrite,
output reg [31:0] WB_read_data,
output reg [31:0] WB_ALU_result,
output reg [4:0] WB_write_register
);


wire MEM_MemtoReg_buf;
wire MEM_RegWrite_buf;
wire [31:0] MEM_ALU_result_buf;
wire [4:0] MEM_write_register_buf;

assign #(clock_delay+1) MEM_MemtoReg_buf = MEM_MemtoReg;
assign #(clock_delay+1) MEM_RegWrite_buf = MEM_RegWrite;
assign #(clock_delay+1) MEM_ALU_result_buf = MEM_ALU_result;
assign #(clock_delay+1) MEM_write_register_buf = MEM_write_register;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        WB_MemtoReg <= 1'b0;
        WB_RegWrite <= 1'b0;
        WB_read_data <= 32'h0000;
        WB_ALU_result <= 32'h0000;
        WB_write_register <= 5'h00;
    end
    else begin
        WB_MemtoReg <= MEM_MemtoReg_buf;
        WB_RegWrite <= MEM_RegWrite_buf;
        WB_read_data <= read_data;
        WB_ALU_result <= MEM_ALU_result_buf;
        WB_write_register <= MEM_write_register_buf;
    end
end    
    
    
endmodule
