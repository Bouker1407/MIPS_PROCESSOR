`timescale 1ns / 1ps
module Forwarding_selector (
input wire [1:0] Forward_in1_sel,
input wire [1:0] Forward_in2_sel,
input wire [31:0] EX_read_data1,
input wire [31:0] EX_read_data2,
input wire [31:0] MEM_ALU_result,
input wire [31:0] WB_write_data_register,
input wire ALUSrc,
input wire [31:0] EX_Immediate_extended,
output reg [31:0] in1_ALU,
output reg [31:0] EX_write_data_mem,
output wire [31:0] in2_ALU
);

always @(*) begin
    case(Forward_in1_sel)
        2'd0: in1_ALU = EX_read_data1; //non-forwarding
        2'd1: in1_ALU = MEM_ALU_result; // EX_EX forwarding
        2'd2: in1_ALU = WB_write_data_register; //MEM_EX forwarding + hazard stalling
        default: in1_ALU = 32'h0000;
    endcase
    
    case(Forward_in2_sel)
        2'd0: EX_write_data_mem = EX_read_data2; //non-forwarding
        2'd1: EX_write_data_mem = MEM_ALU_result; // EX_EX forwarding
        2'd2: EX_write_data_mem = WB_write_data_register; //MEM_EX forwarding + hazard stalling
        default: EX_write_data_mem = 32'h0000;
    endcase  
end

assign in2_ALU = (ALUSrc) ? EX_Immediate_extended : EX_write_data_mem;
endmodule