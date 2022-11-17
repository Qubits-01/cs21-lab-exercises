`timescale  1ns / 1ps

module  flopr_testbench();
    logic   clk, reset;
    logic   [31:0]  d;
    logic   [31:0]  q;
    
    // Instantiate the device under test.
    flopr #(32) instantiated_flopr(clk, reset, d, q);
    
    initial begin
        clk = 0;
        reset = 0;
    end
    
    always 
        #1 clk = ~clk;
        
    always begin
        d = 12; reset = 0;  #2;
        d = 3;  reset = 0;  #2;
        d = -1; reset = 0;  #2;
        d = 32; reset = 1;  #2;
        d = 69; reset = 0;  #2;
        
        $finish;
    end
endmodule
