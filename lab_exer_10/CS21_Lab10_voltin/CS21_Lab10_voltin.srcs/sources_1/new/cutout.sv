`timescale  1ns / 1ps

module  cutout(input    logic           clk,
               input    logic [31:0]    instruction, wd3,
               input    logic           we3, muxcontrol,
               input    logic [2:0]     alucontrol,
               output   logic           zero,
               output   logic [31:0]    result);
    
    logic [4:0] ra1, ra2, wa3;
    assign ra1 = instruction[25:21];
    assign ra2 = instruction[20:16];
    assign wa3 = instruction[15:11];
    
    logic [31:0] rd1, rd2;
    logic [31:0] y_signext, y_mux2;
    
    regfile instantiated_regfile(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);
    signext instantiated_signext(instruction[15:0], y_signext);
    mux2 #(32) instantiated_mux2(rd2, y_signext, muxcontrol, y_mux2);
    alu instantiated_alu(rd1, y_mux2, alucontrol, result, zero);
endmodule
