`timescale 1ns / 1ps


module ALU_control(
input wire [2:0] ALUOp,
input wire [5:0] funct,
output reg [3:0] ALU_control
    );

always @(*) begin
    case(ALUOp)
        3'd0: ALU_control = 4'd0; //lw, sw, addi // add
        3'd1: ALU_control = 4'd9; //beq, bne // sub
        3'd2: begin
            case(funct)
                6'h20: ALU_control = 4'd0; // add
                6'h21: ALU_control = 4'd1; // add unsigned
                6'h24: ALU_control = 4'd2; // and
                6'h27: ALU_control = 4'd3; // nor
                6'h25: ALU_control = 4'd4; // or
                6'h2a: ALU_control = 4'd5; // slt
                6'h2b: ALU_control = 4'd6; // slt unsigned
                6'h00: ALU_control = 4'd7; // sll
                6'h02: ALU_control = 4'd8; // srl
                6'h22: ALU_control = 4'd9; // sub
                6'h23: ALU_control = 4'd10; // sub unsigned
                6'h03: ALU_control = 4'd11; // sra
                default:   ALU_control = 4'd0; // Invalid operation
            endcase
        end
        
        3'd3: ALU_control = 4'd1; // addiu
        3'd4: ALU_control = 4'd2; // andi
        3'd5: ALU_control = 4'd4; // ori
        3'd6: ALU_control = 4'd5; //slti
        3'd7: ALU_control = 4'd6;  //sltiu
        default: ALU_control = 4'd0;
    endcase
end

    
endmodule
