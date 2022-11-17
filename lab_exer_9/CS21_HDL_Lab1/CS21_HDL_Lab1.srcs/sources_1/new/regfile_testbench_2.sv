`timescale  1ns / 1ps

module  regfile_testbench_2();
    logic   clk;
    logic   we3;
    logic   [4:0]   ra1, ra2, wa3;
    logic   [31:0]  wd3;
    logic   [31:0]  rd1, rd2;
    
    // Instantiate device under test.
    regfile instantiated_regfile_2(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
    
    initial begin
//        clk = 0;
//        ra1 = 'b00011;
//        we3 = 1; #1;
//        we3 = 0; #5;
//        wa3 = 'b00011; we3 = 1; wd3 = 'hC0DEBABE; #2;
//        we3 = 0; wd3 = 'hBAADBEEF; #1;
        
        clk = 0;
    end
    
    always begin
        #1 clk = ~clk;
    end
    
    always begin
        // Write the new register values.
        we3 = 1;
        for (int i = 0; i < 32; i = i + 1) begin
            wa3 = i;
            wd3 = i + 2;
            #2;
        end
        
        // Access the register values by 2.
        we3 = 0;
        for (int i = 0; i < 32; i = i + 2) begin
            ra1 = i;
            ra2 = i + 1;
            #1;
        end
        
        $finish;
    end
endmodule
