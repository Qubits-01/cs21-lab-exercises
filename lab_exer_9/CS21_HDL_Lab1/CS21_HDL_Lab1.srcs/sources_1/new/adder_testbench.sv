`timescale  1ns / 1ps

module  adder_testbench();
    logic   clk;
    logic   [15:0] a, b;
    logic          cin;
    logic   [15:0] s;
    logic          cout;
    
    // Instantiate the device under test.
    adder   #(16) instantiated_adder(a, b, cin, s, cout);
    
    initial
        clk = 0;
    
    always 
        #1 clk = ~clk;
        
    always begin
        a = 69;     b = 42;     cin = 0;    #2; // Pair of unique values (1).
        a = 0;      b = 1;      cin = 0;    #2; // Pair of unique values (2).
        a = 32767;  b = 0;      cin = 0;    #2; // Pair of unique values (3).
        a = 1;      b = 32767;  cin = 1;    #2; // Pair of unique values (4).
        a = 12;     b = 45;     cin = 1;    #2; // Pair of unique values (5).
        a = 6969;   b = -4242;  cin = 1;    #2; // Pair of unique values (6).
        a = -34;    b = -53;    cin = 0;    #2; // Pair of unique values (7).
        a = -15;    b = 7;      cin = 1;    #2; // Pair of unique values (8).
        
        $finish;
    end
endmodule
