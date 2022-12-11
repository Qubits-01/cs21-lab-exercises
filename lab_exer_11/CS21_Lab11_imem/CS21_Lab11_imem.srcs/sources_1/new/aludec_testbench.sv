`timescale 1ns / 1ps

module aludec_testbench();
    logic       clk;
    logic [5:0] funct;
    logic [1:0] aluop;
    logic [2:0] alucontrol;
    
    aludec instantiated_aludec(funct, aluop, alucontrol);
    
    initial begin
        clk = 0;
        funct = 0;
        aluop = 0;
    end
    
    always 
        #1 clk = ~clk;
        
    always begin
        funct = 6'b100000; aluop = 2'b00; #2;
        funct = 6'b100010; aluop = 2'b00; #2;
        funct = 6'b100010; aluop = 2'b11; #2;
        funct = 6'b100000; aluop = 2'b10; #2;
        funct = 6'b100100; aluop = 2'b10; #2;
        
        $finish;
    end
endmodule
