`timescale 1ns / 1ps

module imem(input   logic [5:0]     a,
            output  logic [31:0]    rd);
    
    logic [31:0] RAM[63:0];
    
    initial
        $readmemh("memfile.mem", RAM);
        
    assign rd = RAM[a]; // Word alligned.
endmodule
