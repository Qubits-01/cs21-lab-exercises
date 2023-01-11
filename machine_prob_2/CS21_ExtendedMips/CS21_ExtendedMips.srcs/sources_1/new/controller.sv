`timescale 1ns / 1ps

module controller(input  logic [5:0] op, funct,
                  input  logic       zero, gt,
                  output logic       memtoreg, memwrite,
                  output logic       pcsrc, alusrc,
                  output logic       regdst, regwrite,
                  output logic       jump,
                  output logic [2:0] alucontrol);

  logic [2:0] aluop;
  logic       branch;

  maindec md(op, memtoreg, memwrite, branch,
             alusrc, regdst, regwrite, jump, aluop);
  aludec  ad(funct, aluop, alucontrol);

  assign pcsrc = branch & (((op == 6'b000100) & zero) | ((op == 6'b011100) & gt));
endmodule
