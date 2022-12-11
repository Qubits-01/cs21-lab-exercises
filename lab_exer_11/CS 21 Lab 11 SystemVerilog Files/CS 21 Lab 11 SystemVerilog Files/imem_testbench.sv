`timescale 1ns / 1ps


module dmem_testbench();

logic [5:0] a;
logic [31:0] rd;

imem instantiated_imem(a, rd);

  initial begin

    a = 'b00000; #2;    
    a = 'b00001; #2;  
    a = 'b00010; #2;
    a = 'b00011; #2;

  end


endmodule