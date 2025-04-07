`timescale 1ns / 1ps


module Forwarding_unit_tb();

reg MEM_RegWrite;
reg WB_RegWrite;
reg [4:0] MEM_write_register;
reg [4:0] WB_write_register;
reg [4:0] EX_rs;
reg [4:0] EX_rt;
wire [1:0] Forward_in1_sel;
wire [1:0] Forward_in2_sel;

Forwarding_unit fu(.*);

initial begin
    #100;
    MEM_RegWrite = 1;
    WB_RegWrite = 1;
    MEM_write_register = 12;
    WB_write_register = 2;
    EX_rs = 6;
    EX_rt = 2;
    
    #100;
    MEM_RegWrite = 1;
    WB_RegWrite = 1;
    MEM_write_register = 2;
    WB_write_register = 2;
    EX_rs = 6;
    EX_rt = 2;
    
    #10;
    
    
    $finish;

end



endmodule
