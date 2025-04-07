`timescale 1ns / 1ps

module PC_calculator #(clock_delay = 20) (
input wire [31:0] PC4,
input wire [3:0] ID_PC4_splitted,
input wire [31:0] EX_PC4,
input wire [25:0] Jump_address,
input wire [31:0] EX_Immediate_extended,
input wire [31:0] in1_ALU,
input wire Jump,
input wire IF_ID_flush,
input wire [1:0] Branch,
input wire Zeroflag,
input wire JR,
output wire [31:0] out_pc_cal,
output jump_ctrl
    );

wire branch_ctrl, jump_ctrl, jump_ctrl_buf, jr_ctrl, branch_ctrl_early;

wire [31:0] PC_jump, PC_jump_buf, PC_branch, PC_branch_buf, PC_jr, PC_jr_buf, PC4_buf;
wire [31:0] Immediate_sll;
wire [31:0] mux_branch, mux_jump, mux_jr;

Shifter shiftleftPC_jump(.in1({2'b00, ID_PC4_splitted, Jump_address}), .shamt(5'd2), .shifter_select(2'd1), .shifter_result(PC_jump));

Shifter shiftleftImmediate(.in1(EX_Immediate_extended), .shamt(5'd2), .shifter_select(2'd1), .shifter_result(Immediate_sll));
Adder add_PC4_Imm(.in1(EX_PC4), .in2(Immediate_sll), .adder_result(PC_branch));

assign PC_jr = in1_ALU;

assign  branch_ctrl_early = Branch[1] & (Branch[0] & Zeroflag | ~Branch[0] & ~Zeroflag);
assign  #(clock_delay+1) branch_ctrl = Branch[1] & (Branch[0] & Zeroflag | ~Branch[0] & ~Zeroflag);
assign  #(clock_delay+1) jump_ctrl = Jump & (~IF_ID_flush) & (~branch_ctrl_early);
//assign #(clock_delay) jump_ctrl_buf = jump_ctrl;
assign  #(clock_delay+1) jr_ctrl = JR; 

assign #(clock_delay+1) PC_jump_buf = PC_jump;
assign #(clock_delay+1) PC_branch_buf = PC_branch;
assign #(clock_delay+1) PC_jr_buf = PC_jr;

assign #(clock_delay+1) PC4_buf = PC4;
assign mux_branch = (branch_ctrl) ? PC_branch_buf : PC4;
assign mux_jump = (jump_ctrl) ? PC_jump_buf : mux_branch;
assign mux_jr = (jr_ctrl) ? PC_jr_buf : mux_jump;



assign out_pc_cal = mux_jr;

endmodule
