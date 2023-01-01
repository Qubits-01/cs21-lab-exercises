`timescale 1ns / 1ps

module ori_testbench();
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
        if(dataadr === 0 & writedata === 13) begin
          $display("[PASSED] Should be dataadr = 0, writedata = 13 | mem[0] = 13");
        end else if(dataadr === 4 & writedata === 2) begin
          $display("[PASSED] Should be dataadr = 4, writedata = 2 | mem[4] = 2");
        end else if(dataadr === 8 & writedata === -3) begin
          $display("[PASSED] Should be dataadr = 8, writedata = -3 | mem[8] = -3");
          $finish;
        end else begin
          $display("Simulation failed!!!");
          $finish;
        end
      end
    end
endmodule
