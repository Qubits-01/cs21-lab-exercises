`timescale 1ns / 1ps

module imem_testbench();
    logic [5:0]     a;
    logic [31:0]    rd;
    
    imem instantiated_imem(a, rd);
    
    initial begin
        for (int bin_input = 0; bin_input < 64; bin_input = bin_input + 1) begin
            a = bin_input; #2;
        end
        
        $finish;
    end
endmodule
