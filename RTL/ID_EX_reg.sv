`timescale 1ns / 1ps


module ID_EX_reg #(clock_delay = 20)(
input wire clk,
input wire rst_n,
input wire [31:0] ID_PC4,
input wire [10:0] ID_control_words,
input wire [31:0] read_data1,
input wire [31:0] read_data2,
input wire [31:0] Immediate_extended,
input wire [14:0] rs_rt_rd,
//input wire [5:0] shamt,
output reg [31:0] EX_PC4,
output reg [10:0] EX_control_words,
output reg [31:0] EX_read_data1,
output reg [31:0] EX_read_data2,
output reg [31:0] EX_Immediate_extended,
output reg [14:0] EX_rs_rt_rd
//output reg [5:0] EX_shamt
);

wire [31:0] ID_PC4_buf;
wire [10:0] ID_control_words_buf;
wire [31:0] Immediate_extended_buf;
wire [14:0] rs_rt_rd_buf;

assign #(clock_delay+1) ID_PC4_buf = ID_PC4;
assign #(clock_delay+1) ID_control_words_buf = ID_control_words;
assign #(clock_delay+1) Immediate_extended_buf = Immediate_extended;
assign #(clock_delay+1) rs_rt_rd_buf = rs_rt_rd;

    // control words: | RegDst | Branch(2bit) | MemRead | MemtoReg | ALuop(3bit) | MemWrite | ALUSrc | RegWrite |
// branch[1] is branch, branch[0] = 1 : beq else bne
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        EX_PC4 <= 32'h0000;
        EX_control_words <= 11'h000;
        EX_read_data1 <= 32'h0000;
        EX_read_data2 <= 32'h0000;
        EX_Immediate_extended <= 32'h0000;
        EX_rs_rt_rd <= 15'h0000;
//        EX_shamt <= 6'h00;
    end
    else begin
        EX_PC4 <= ID_PC4_buf;
        EX_control_words <= ID_control_words_buf;
        EX_read_data1 <= read_data1;
        EX_read_data2 <= read_data2;
        EX_Immediate_extended <= Immediate_extended_buf;
        EX_rs_rt_rd <= rs_rt_rd_buf; 
//        EX_shamt <= shamt;       
    end
end

endmodule
