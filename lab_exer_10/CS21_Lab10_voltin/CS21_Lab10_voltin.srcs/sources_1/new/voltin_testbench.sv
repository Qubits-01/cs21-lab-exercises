`timescale 1ns / 1ps

module voltin_testbench();
    logic [31:0] a, b;
    logic cin;
    logic [31:0] finout;
    logic cout;
    logic clk; 
    
    // instantiate device under test
    voltin instantiated_voltin(a, b, cin, finout, cout);

    initial begin
        clk = 0;
        cin = 0;
        a = 'h00000001; b = 'h00000005; cin = 'b0; #2;    
        a = 'h00000002; b = 'h00000006; cin = 'b0; #2;  
        a = 'h00000003; b = 'h00000007; cin = 'b0; #2;
        a = 'h00000004; b = 'h00000008; cin = 'b0; #2;    
    end

    always begin
        #1 clk = ~clk; 
    end
endmodule
