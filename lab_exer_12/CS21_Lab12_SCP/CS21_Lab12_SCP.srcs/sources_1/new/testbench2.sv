`timescale 1ns / 1ps

module testbench();
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
        if(dataadr === 12 & writedata === 0) begin
          $display("Correct: dataadr = 12; writedata = 10");
          $stop;
        end else if (dataadr === 16 & writedata === 0) begin
          $display("Correct: dataadr = 16; writedata = 0");
          $stop;
        end
      end
    end
endmodule
