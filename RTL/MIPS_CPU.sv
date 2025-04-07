`timescale 1ns / 1ps

module MIPS_CPU #(clock_delay = 20)(
input wire clk,
input wire rst_n,
input wire enable
);

//      IF STAGE

//IF buffer
wire [31:0] PC_in;
wire IF_flush;

IF_buffer if_buf (.*);

//PC reg
wire [31:0] PC;

PC_register     pc_reg(.*);

//local vars of stage
wire [31:0] PC4;

assign PC4 = PC + 4;

//Instruction mem
wire [31:0] Instruction;

Instruction_Mem ins_mem (.*);

//      ID STAGE

//IF_ID_reg
wire [31:0] ID_PC4;
wire [31:0] ID_Instruction;
wire IF_ID_flush;

IF_ID_reg ifid_reg(.*);

//local vars of stage
wire [25:0] Jump_address;
wire [5:0] opcode;
wire [4:0] read_register1, read_register2;
wire [15:0] Immediate;
wire [14:0] rs_rt_rd;

assign Jump_address = ID_Instruction[25:0];
assign {opcode, read_register1, read_register2, Immediate} = ID_Instruction;
assign rs_rt_rd = ID_Instruction[25:11];
assign {rs, rt} = ID_Instruction[25:16];

//Control unit
wire [12:0] control_words;
wire Jump, SignZero; 

assign {Jump, SignZero} = {control_words[11], control_words[0]};
Control_unit    cu(.*);

//Flush control
wire [10:0] control_words_splitted;
wire [10:0] ID_control_words;

assign control_words_splitted = {control_words[12], control_words[10:1]};
Flush_control flush_ctrl(.*);

//Register file
wire [31:0] read_data1;
wire [31:0] read_data2;

Registers       rf(.*);

//WB forwarding unit
//wire [31:0] read_data1_out;
//wire [31:0] read_data2_out;

//WB_forwarding_unit #(clock_delay) wb_fw_unit (.*);

//Sign Zero extend

wire [31:0] Immediate_extended;

SignZero_extend sz_ex(.*);

//      EX STAGE

//ID_EX_reg
wire [31:0] EX_PC4;
wire [10:0] EX_control_words;
wire [31:0] EX_read_data1;
wire [31:0] EX_read_data2;
wire [31:0] EX_Immediate_extended;
wire [14:0] EX_rs_rt_rd;

ID_EX_reg #(clock_delay) idex_reg  (.*);

//local var of stage     // control words: | RegDst | Branch(2bit) | MemRead | MemtoReg | ALuop(3bit) | MemWrite | ALUSrc | RegWrite |
wire RegDst, EX_MemRead, EX_MemtoReg, EX_MemWrite, ALUSrc, EX_RegWrite;
wire [1:0] Branch;
wire [2:0] ALUOp;
wire [4:0] shamt;
wire [5:0] funct;
wire [4:0] EX_rs, EX_rt, EX_rd;


assign {RegDst, Branch, EX_MemRead, EX_MemtoReg, ALUOp, EX_MemWrite, ALUSrc, EX_RegWrite} = EX_control_words;
assign {shamt, funct} = EX_Immediate_extended[10:0];
assign {EX_rs, EX_rt, EX_rd} = EX_rs_rt_rd;


//Forwarding selector
wire [31:0] in1_ALU;
wire [31:0] EX_write_data_mem;
wire [31:0] in2_ALU;

Forwarding_selector fw_sel(.*);

//ALU control
wire [3:0] ALU_control;

ALU_control     alu_control(.*);

//ALU
wire [31:0] ALU_result;
wire Zeroflag;

ALU             #(clock_delay) alu(.*);

//JR control
wire JR;

JR_control      jr_ctrl(.*);

//write register selector
wire [4:0] EX_write_register;

assign EX_write_register = (RegDst) ? EX_rd : EX_rt;

//      MEM STAGE

//EX_MEM_reg
wire MEM_MemRead;
wire MEM_MemtoReg;
wire MEM_MemWrite;
wire MEM_RegWrite;
wire [31:0] MEM_ALU_result;
wire [31:0] MEM_write_data_mem;
wire [4:0] MEM_write_register;

EX_MEM_reg #(clock_delay) exmem_reg(.*);

//local vars of stage
wire MemWrite;
wire MemRead;
wire [31:0] dmem_address;
wire [31:0] write_data_mem;

assign {MemWrite, MemRead, dmem_address, write_data_mem} = {MEM_MemWrite, MEM_MemRead, MEM_ALU_result, MEM_write_data_mem};

//Data mem

wire [31:0] read_data;

Data_Mem        data_mem(.*);

//      WB STAGE

//MEM_WB_reg
wire WB_MemtoReg;
wire WB_RegWrite;
wire [31:0] WB_read_data;
wire [31:0] WB_ALU_result;
wire [4:0] WB_write_register;

MEM_WB_reg #(clock_delay) memwb_reg(.*);

//local vars of stage
wire [31:0] WB_write_data_register, write_data_register;
wire RegWrite;
wire [4:0] write_register;

assign WB_write_data_register = (WB_MemtoReg) ? WB_read_data : WB_ALU_result;
assign write_data_register = WB_write_data_register;
assign RegWrite = WB_RegWrite;
assign write_register = WB_write_register;

//      Controller modules

//PC calculator
//input 
wire [3:0] ID_PC4_splitted;

//output
wire [31:0] out_pc_cal;
wire jump_ctrl;


assign ID_PC4_splitted = ID_PC4[31:28];
PC_calculator   #(clock_delay) pc_cal(.*);

//Stall control
//input
wire [4:0] ID_rs;
wire [4:0] ID_rt;
wire branch_control;


assign {ID_rs, ID_rt} = ID_Instruction[25:16];
assign branch_control = Branch[1] & ((Branch[0] & Zeroflag) | ((~Branch[0]) & (~Zeroflag)));
//output
wire PC_write_en;
wire IF_ID_write_en;
wire stall_flush;

Stall_control #(clock_delay) stall_ctrl(.*);

//Discard instruction
wire IF_flush_buf;
wire ID_flush;

Discard_instruction discard_instr(.*);

//Forwarding unit
wire [1:0] Forward_in1_sel;
wire [1:0] Forward_in2_sel;

Forwarding_unit fw_unit(.*);




endmodule
