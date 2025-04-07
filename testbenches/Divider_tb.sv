`timescale 1ns / 1ps


module Divider_tb();

reg clk;               // Clock signal
reg rst_n;             // Reset signal
reg start;            // Start signal to begin division
reg [31:0] in1;        // Dividend
reg [31:0] in2;        // Divisor
reg select;            // Select for signed division
wire [31:0] LO;         // Quotient
wire [31:0] HI;         // Remainder
wire divide_by_zero;    // Divide by zero flag
wire done;               // Done signal

Divider div(.*);

initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

initial begin
    rst_n = 0;
    #100 rst_n = 1;
end

initial begin
    start = 0;
    in1 = 0;
    in2 = 0;
    select = 0;
    @(posedge rst_n)
    @(posedge clk)
    #1; 
    in1 = $urandom_range(9999,0);
    in2 = $urandom_range(100,0);
    select = $random; 
    start = 1;
    @(posedge clk)
    #1;
    start = 0;
    select = 0;
    @(posedge done)
    @(posedge clk)
    rst_n = 0;
    @(posedge clk)
    rst_n = 1;
    
    @(posedge clk)
    #1; 
    in1 = $random;
    in2 = 0;
    select = 0; 
    start = 1;
    @(posedge clk)
    #1;
    start = 0;
    select = 0;

    @(posedge clk)
    rst_n = 0;
    in1 = 0;
    in2 = 0;
    @(posedge clk)
    rst_n = 1;
    
    @(posedge clk)
    #1; 
    in1 = $urandom_range(10000,0);
    in2 = std::randomize() with {in2[31] == 1; in2[30:0] < 200;};
    select = 1; 
    start = 1;
    @(posedge clk)
    #1;
    start = 0;
    select = 0;
    @(posedge done)
    @(posedge clk)
    rst_n = 0;
    in1 = 0;
    in2 = 0;
    @(posedge clk)
    rst_n = 1;

end



endmodule
