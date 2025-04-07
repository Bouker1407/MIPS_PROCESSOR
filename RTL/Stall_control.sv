`timescale 1ns / 1ps


module Stall_control #(clock_delay = 20)( // data hazard detection and structural hazard detection (for only at register file)
input wire EX_MemRead,
input wire [4:0] EX_rt,
input wire [4:0] ID_rs,
input wire [4:0] ID_rt,
input wire [5:0] opcode,
input wire WB_RegWrite,
input wire jump_ctrl,
input wire branch_control,
input wire JR,
output reg PC_write_en,
output reg IF_ID_write_en,
output reg stall_flush
    );
// (EX_MemRead==1&&(EX_rt==ID_rs||(EX_rt==ID_rt && Opcode != 6'b001110 && Opcode!= 6'b100011)))
 // dk stall là lệnh trước là lw load vô rt, lệnh sau thì nếu R type thì EX_rt phải được dùng lại (EX_rt == rt || EX_rt == rs), còn I type thì EX_rt == rs (ngoại trừ beq và bne)

wire branch_control_buf1, branch_control_buf2;
wire JR_buf1, JR_buf2;

assign #(clock_delay) branch_control_buf1 = branch_control;
assign #(clock_delay) branch_control_buf2 = branch_control_buf1;

assign #(clock_delay) JR_buf1 = JR;
assign #(clock_delay) JR_buf2 = JR_buf1;

always @(*) begin
    if (EX_MemRead & ((EX_rt == ID_rs) | ((EX_rt == ID_rt) & ((opcode == 6'h0) | (opcode == 6'h04) | (opcode == 6'h05)))))   begin
        PC_write_en = 1'b0;
        IF_ID_write_en = 1'b0;
        stall_flush = 1'b1;
    end
    else if (branch_control_buf2 | JR_buf2) begin
        PC_write_en = 1'b1;
        IF_ID_write_en = 1'b1;
        stall_flush = 1'b0;         
    end
    else if (WB_RegWrite) begin
        PC_write_en = 1'b0;
        IF_ID_write_en = 1'b0;
        stall_flush = 1'b1;    
    end
    else begin
        PC_write_en = 1'b1;
        IF_ID_write_en = 1'b1;
        stall_flush = 1'b0;    
    end
    
end
    
 
endmodule
