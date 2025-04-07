`timescale 1ns / 1ps


module Forwarding_unit(
input wire MEM_RegWrite,
input wire WB_RegWrite,
input wire [4:0] MEM_write_register,
input wire [4:0] WB_write_register,
input wire [4:0] EX_rs,
input wire [4:0] EX_rt,
output reg [1:0] Forward_in1_sel,
output reg [1:0] Forward_in2_sel
    );
 
assign Forward_in1_sel[0] = MEM_RegWrite & (MEM_write_register != 0) & (MEM_write_register == EX_rs); //EX_EX
assign Forward_in1_sel[1] = (~Forward_in1_sel[0]) & WB_RegWrite & (WB_write_register != 0) & (WB_write_register == EX_rs); //MEM_EX

assign Forward_in2_sel[0] = MEM_RegWrite & (MEM_write_register != 0) & (MEM_write_register == EX_rt);
assign Forward_in2_sel[1] = (~Forward_in2_sel[0]) & WB_RegWrite & (WB_write_register != 0) & (WB_write_register == EX_rt);

//always @(*) begin
//    if (MEM_RegWrite & (MEM_write_register != 0) & (MEM_write_register == EX_rs)) begin
//        Forward_in1_sel = 2'd1;
//    end
//    else if (WB_RegWrite & (WB_write_register != 0) & (WB_write_register == EX_rs)) begin
//        Forward_in1_sel = 2'd2;
//    end
//    else begin
//        Forward_in1_sel = 2'd0;
//    end
//end 

/*
 foward = 0 => not forwarding
 forward = 1 => MEM_ALU_result (EX-EX)
 forward = 2 => WB_write_data_register (MEM-EX)
for both rs and rt

*/
 
endmodule
