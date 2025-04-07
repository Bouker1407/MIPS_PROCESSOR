`timescale 1ns / 1ps

module MIPS_CPU_tb();
parameter clock_delay = 20;
reg clk, rst_n, enable;

MIPS_CPU  #(clock_delay) cpu(.*);

wire [31:0] PC, Instruction;
wire [31:0] RF [0:31];
wire [7:0] instruction_memory [0:2047];

wire [7:0] data_memory [0:2047];
assign data_memory = cpu.data_mem.memory;

assign RF = cpu.rf.RF;
assign PC = cpu.PC;
assign instruction_memory = cpu.ins_mem.memory;
assign Instruction = cpu.Instruction;

wire [31:0] out_pc_cal;
assign out_pc_cal = cpu.pc_cal.out_pc_cal;

wire [31:0] PC_in;
assign PC_in = cpu.if_buf.PC_in;

wire PC_write_en;
assign PC_write_en = cpu.pc_reg.PC_write_en;

wire WB_RegWrite;
assign WB_RegWrite = cpu.WB_RegWrite;

wire [31:0] ID_Instruction;
assign ID_Instruction = cpu.ID_Instruction;

wire EX_RegWrite;
assign EX_RegWrite = cpu.EX_RegWrite;

wire [4:0] EX_write_register;
assign EX_write_register = cpu.EX_write_register;

wire [4:0] EX_rd, EX_rt, EX_rs;
assign EX_rd = cpu.EX_rd;
assign EX_rt = cpu.EX_rt;
assign EX_rs = cpu.EX_rs;

wire RegDst;
assign RegDst = cpu.RegDst;

wire [4:0] rs, rt, rd;
assign {rs, rt, rd} = cpu.rs_rt_rd;

wire [31:0] write_data_register;
assign write_data_register = cpu.write_data_register;

wire [4:0] write_register;
assign write_register = cpu.write_register;

wire WB_MemtoReg;
assign WB_MemtoReg = cpu.WB_MemtoReg;

wire [31:0] WB_read_data;
assign WB_read_data = cpu.WB_read_data;

wire branch_control;
assign branch_control = cpu.branch_control;

wire [1:0] Branch;
assign Branch = cpu.Branch;

wire ALUSrc;
assign ALUSrc = cpu.ALUSrc;


wire [31:0] in1_ALU, in2_ALU;
assign in1_ALU = cpu.in1_ALU;
assign in2_ALU = cpu.in2_ALU;

//wire [1:0] Forward_in1_sel;
//wire [1:0] Forward_in2_sel;
//assign Forward_in1_sel = cpu.Forward_in1_sel;
//assign Forward_in2_sel = cpu.Forward_in2_sel;

wire [31:0] EX_Immediate_extended, ID_PC4;
assign EX_Immediate_extended = cpu.EX_Immediate_extended;
assign ID_PC4 = cpu.ID_PC4;

wire IF_ID_write_en;
assign IF_ID_write_en = cpu.IF_ID_write_en;

wire jump_ctrl;
assign jump_ctrl = cpu.pc_cal.jump_ctrl;

wire flush, stall_flush, IF_ID_flush, ID_flush;
assign flush = cpu.flush_ctrl.flush;
assign stall_flush = cpu.flush_ctrl.stall_flush;
assign IF_ID_flush = cpu.flush_ctrl.IF_ID_flush;
assign ID_flush = cpu.flush_ctrl.ID_flush;

wire jr_ctrl;
assign jr_ctrl = cpu.pc_cal.jr_ctrl;

wire JR;
assign JR = cpu.pc_cal.JR;

wire [10:0] ID_control_words, EX_control_words;
assign ID_control_words = cpu.ID_control_words;
assign EX_control_words = cpu.EX_control_words;

initial begin
    clk = 0;
    forever #(clock_delay/2) clk = ~clk;
end

initial begin
    rst_n = 0;
    #100;
    rst_n = 1;
end

initial begin
    wait (rst_n === 1);
    #1;
    $readmemb("D:/Crucial_files/UIT/LLS/project/instruction_data/sum_one_to_n.txt", cpu.ins_mem.memory);
    @(posedge clk)
    #1 enable = 1;
    #50000;
    $finish;
end


bit[15:0] num_arr; 
int element_rand, addr;
int arr[$];


int array_file, instruction_file;

string instruction_queue[$], program_queue[$];
string line, temp_str;

initial begin
    wait (rst_n === 1);
    num_arr = 5;/*$urandom_range(1,100);*/
//    temp_str = $sformatf("00100000 00001101 %b %b", num_arr[15:8], num_arr[7:0]);
    
//    instruction_file = $fopen("D:/Crucial_files/UIT/LLS/project/instruction_data/sort_binary.txt", "r");
//    while (!$feof(instruction_file)) begin
//        $fgets(line, instruction_file);
//        instruction_queue.push_back(line);
//    end
//    $fclose(instruction_file);
    
//    instruction_queue[1] = temp_str;
    
//    instruction_file = $fopen("D:/Crucial_files/UIT/LLS/project/instruction_data/sort_binary.txt", "w");    
//    while (instruction_queue.size() > 0) begin
//        $fwrite(instruction_file, "%s\n", instruction_queue.pop_front());
//    end
//    $fclose(instruction_file);
////    $writememb("D:/Crucial_files/UIT/LLS/project/instruction_data/sort_binary.txt", instruction_queue);
//    addr = 0;
//    repeat (num_arr) begin
//        element_rand = $urandom_range(1,200);
//        arr.push_back(element_rand);
//        {cpu.data_mem.memory[addr], cpu.data_mem.memory[addr+1], cpu.data_mem.memory[addr+2], cpu.data_mem.memory[addr+3]} = element_rand;
//        addr += 4;
//    end
    
    
    
//    array_file = $fopen("D:/Crucial_files/UIT/LLS/project/instruction_data/array.txt", "w");
//    while (arr.size() > 0) begin
//        $fwrite(array_file, "%0d\n", arr.pop_front()); 
//    end
//    $fclose(array_file);
end

endmodule
