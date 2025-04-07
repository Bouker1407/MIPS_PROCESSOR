`timescale 1ns / 1ps

module Shifter(
input wire [31:0] in1,
input wire [4:0] shamt,
input wire [1:0] shifter_select,
output reg [31:0] shifter_result
    );

always @(*) begin
    case(shifter_select)
        2'd1: shifter_result = in1 << shamt; //sll
        2'd2: shifter_result = in1 >> shamt; // srl
        2'd3: shifter_result = $signed(in1) >>> shamt; // sra
        default: shifter_result = 32'd0;
    endcase
end
endmodule
