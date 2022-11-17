`timescale  1ns / 1ps

module  regfile_testbench();
    logic   clk;
    logic   we3;
    logic   [4:0]   ra1, ra2, wa3;
    logic   [31:0]  wd3;
    logic   [31:0]  rd1, rd2;
    
    // instantiate device under test 
    regfile instantiated_regfile(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
    
    initial begin
       clk = 0;
       ra1 = 'b00011;
       we3 = 1; #1;
       we3 = 0; #5;
       wa3 = 'b00011; we3 = 1; wd3 = 'hC0DEBABE; #2;
       we3 = 0; wd3 = 'hBAADBEEF; #1;
    end
    
    always begin
        #1 clk = ~clk;
    end
endmodule
