`timescale  1ns / 1ps

module  signext_testbench();
    logic   clk;
    logic   [15:0] a;
    logic   [31:0] y;
    
    // Instantiate the device under test.
    signext instantiated_signext(a, y);
    
    initial
        clk = 0;
        
    always 
        #1 clk = ~clk;
        
    always begin
        a = 0;  #2;
        a = 42; #2;
        a = 69; #2;
        a = -1; #2;
        a = -69; #2;
        
        $finish;
    end
endmodule
