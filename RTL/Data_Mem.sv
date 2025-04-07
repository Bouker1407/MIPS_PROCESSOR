`timescale 1ns / 1ps
module Data_Mem(
input wire clk,
input wire rst_n,
input wire MemWrite,
input wire MemRead,
input wire [31:0] dmem_address,
input wire [31:0] write_data_mem,
output wire [31:0] read_data
    );
    
reg [7:0] memory [0:2047];
reg [31:0] read_data_buf;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        memory <= '{default: '0};
        read_data_buf <= 32'h0000;
    end
    else begin
        if (MemWrite)
            {memory[dmem_address], memory[dmem_address+1], memory[dmem_address+2], memory[dmem_address+3]} <= write_data_mem;
        else if (MemRead)
            read_data_buf <= {memory[dmem_address], memory[dmem_address+1], memory[dmem_address+2], memory[dmem_address+3]};
    end
end

assign read_data = read_data_buf;

endmodule
