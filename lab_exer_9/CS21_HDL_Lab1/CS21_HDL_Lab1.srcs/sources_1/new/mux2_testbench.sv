`timescale  1ns / 1ps

module  mux2_testbench();
    logic           clk;
    logic   [31:0]  d0, d1;
    logic           s;
    logic   [31:0]  y;
    
    // Instantiate the device under test.
    mux2 #(32)  instantiated_mux2(d0, d1, s, y);
    
    initial begin
        clk = 0;
        s = 0;
    end
    
    always 
        #1 clk = ~clk;
        
    always begin
        d0 = 42;    d1 = 69;    s = 0;  #2;
        d0 = -1;    d1 = -2;    s = 1;  #2;
        d0 = 34;    d1 = 32;    s = 0;  #2;
        d0 = 5;     d1 = 4;     s = 1;  #2;
        d0 = 0;     d1 = 23;    s = 1;  #2;
        
        $finish;
    end
endmodule
