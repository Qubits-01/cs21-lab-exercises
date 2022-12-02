`timescale 1ns / 1ps

module alu_testbench();
    logic [31:0] a, b;
    logic [2:0]  alucontrol;
    logic [31:0] result;
    logic        zero;
    logic        clk;
    
    // instantiate device under test
    alu instantiated_alu(a, b, alucontrol, result, zero);

    initial begin
        clk = 0;
        a = 0; b = 0;   
    end

    always begin
        #1 clk = ~clk; 
    end
    
    always begin
        a = 32'hDEAD0000; b = 32'h0000BEEF; alucontrol = 3'b010; #2;
        a = 32'hC0DEBABE; b = 32'h0000FFFF; alucontrol = 3'b000; #2;
        a = 32'hC0DE0000; b = 32'h0000BABE; alucontrol = 3'b001; #2;
        a = 32'hC0DEBABE; b = 32'h0000BABE; alucontrol = 3'b110; #2;
        
        $finish;
    end
endmodule
