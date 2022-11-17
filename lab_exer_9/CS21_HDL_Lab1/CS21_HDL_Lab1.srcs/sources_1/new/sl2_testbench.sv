`timescale  1ns / 1ps

module  sl2_testbench();
    logic   clk;
    logic   [31:0] a;
    logic   [31:0] y;
    
    // Instantiate the device under test.
    sl2 instantiated_sl2(a, y);
    
    initial
        clk = 0;
    
    always 
        #1 clk = ~clk;
        
    always begin
        a = 0;  #2;
        a = 42; #2;
        a = 69; #2;
        a = -1; #2;
        a = 21; #2;
        
        $finish;
    end
endmodule
