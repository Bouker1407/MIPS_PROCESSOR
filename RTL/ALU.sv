`timescale 1ns / 1ps
module ALU #(clock_delay = 20) (
input wire [3:0] ALU_control,
input wire [31:0] in1_ALU,
input wire [31:0] in2_ALU,
input wire [4:0] shamt,
output wire [31:0] ALU_result,
output wire Zeroflag
    );
reg [1:0] shifter_select;
reg sub_select;
wire [31:0] adder_result, sub_result, shifter_result;


always @(*) begin
    case(ALU_control)
        4'd7: begin
            shifter_select = 2'd1;
            sub_select = 1'bx;
        end
        4'd8: begin
            shifter_select = 2'd2;
            sub_select = 1'bx;
        end
        4'd9: begin 
            sub_select = 1'b0;
            shifter_select = 1'bx;
        end
        4'd10: begin 
            sub_select = 1'b1;
            shifter_select = 1'bx;
        end
        4'd11: begin
            shifter_select = 2'd3;
            sub_select = 1'bx;
        end
        default: begin
            shifter_select = 1'bx;
            sub_select = 1'bx;
        end
    endcase
end

reg [31:0] result_buf;
wire zeroflag_buf;

always @(*) begin
    case(ALU_control)
        4'd0, 4'd1: result_buf = adder_result;
        4'd2: result_buf = in1_ALU & in2_ALU;
        4'd3: result_buf = ~(in1_ALU | in2_ALU);
        4'd4: result_buf = in1_ALU | in2_ALU;
        4'd5: result_buf = ($signed(in1_ALU) < $signed(in2_ALU)) ? 1 : 0;
        4'd6: result_buf = (in1_ALU < in2_ALU) ? 1 : 0;
        4'd7, 4'd8, 4'd11: result_buf = shifter_result;
        4'd9, 4'd10: result_buf = sub_result;
        default: result_buf = 32'h0;
    endcase
end

Adder add(.in1(in1_ALU), .in2(in2_ALU), .adder_result(adder_result));
Subtractor sub(.in1(in1_ALU), .in2(in2_ALU), .sub_select(sub_select), .sub_result(sub_result));
Shifter shift(in1_ALU, shamt, shifter_select, shifter_result);

assign zeroflag_buf = (sub_result == 0) ? 1'b1 : 1'b0;

assign  #(clock_delay+1) ALU_result = result_buf;
assign  Zeroflag = zeroflag_buf; 

endmodule
