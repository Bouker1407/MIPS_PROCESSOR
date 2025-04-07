`timescale 1ns / 1ps

module WB_forwarding_unit #(clock_delay =20)(
input wire RegWrite,
input wire [4:0] rs,
input wire [4:0] rt,
input wire [4:0] write_register,
input wire [31:0] read_data1,
input wire [31:0] read_data2,
input wire [31:0] write_data_register,
output reg [31:0] read_data1_out,
output reg [31:0] read_data2_out
    );
    
wire RegWrite_buf;
wire [4:0] rs_buf;
wire [4:0] rt_buf;
wire [4:0] write_register_buf;
wire [31:0] write_data_register_buf;

assign #(clock_delay+1) RegWrite_buf = RegWrite;
assign #(clock_delay+1) rs_buf = rs;
assign #(clock_delay+1) rt_buf = rt;
assign #(clock_delay+1) write_register_buf = write_register;
assign #(clock_delay+1) write_data_register_buf = write_data_register;

always @(*) begin
    if (RegWrite & (write_register_buf != 0) & (write_register_buf == rs_buf))
        read_data1_out = write_data_register;
    else
        read_data1_out = read_data1;
        
    if (RegWrite & (write_register_buf != 0) & (write_register_buf == rt_buf))
        read_data2_out = write_data_register;
    else
        read_data2_out = read_data1;
end
    
    
endmodule
