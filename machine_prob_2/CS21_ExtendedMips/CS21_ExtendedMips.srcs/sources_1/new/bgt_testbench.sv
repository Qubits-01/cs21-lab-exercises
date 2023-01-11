`timescale 1ns / 1ps

module bgt_testbench();
  logic        clk;
  logic        reset;

  logic [31:0] writedata, dataadr;
  logic        memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);
  
  // initialize test
  initial
    begin
      reset <= 1; # 22; reset <= 0;
    end

  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check results
  always @(negedge clk)
    begin
      if(memwrite) begin
        if(dataadr === 0 & writedata === 4) begin
          $display("[PASSED] Should be dataadr = 0, writedata = 4 | mem[0] = 4");
          $finish;
        end else begin
          $display("Simulation failed!!!");
          $finish;
        end
      end
    end
endmodule
