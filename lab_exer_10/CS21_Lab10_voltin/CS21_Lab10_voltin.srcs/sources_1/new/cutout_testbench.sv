`timescale 1ns / 1ps

module cutout_testbench();
    logic           clk;
    logic [31:0]    instruction, wd3;
    logic           we3, muxcontrol;
    logic [2:0]     alucontrol;
    logic           zero;
    logic [31:0]    result;
    
    // Instantiate the device under test.
    cutout intantiated_cutout(clk, instruction, wd3, we3,
                              muxcontrol, alucontrol,
                              zero, result);
    
    logic [4:0] ra1, ra2, wa3;
    
    initial begin
        clk = 0;
        instruction = 0; wd3 = 0;
        we3 = 0; muxcontrol = 0; alucontrol = 0;
        
        ra1 = 0; ra2 = 0; wa3 = 0;
    end
    
    always 
        #1 clk = ~clk;
    
    always begin
        // Writing 0xC0DE0000 to register 1.
        ra1 = 5'b00000; ra2 = 5'b00000; wa3 = 5'b00001;
        instruction = {{6{1'b0}}, ra1, ra2, wa3, {11{1'b0}}};
        wd3 = 32'hC0DE0000;
        we3 = 1; muxcontrol = 0; alucontrol = 3'b000;
        #2;
        
        // Writing 0x0000BABE to register 2.
        ra1 = 5'b00000; ra2 = 5'b00000; wa3 = 5'b00010;
        instruction = {{6{1'b0}}, ra1, ra2, wa3, {11{1'b0}}};
        wd3 = 32'h0000BABE;
        we3 = 1; muxcontrol = 0; alucontrol = 3'b000;
        #2;
        
        // Addition of register 1 and register 2.
        ra1 = 5'b00001; ra2 = 5'b00010; wa3 = 5'b00000;
        instruction = {{6{1'b0}}, ra1, ra2, wa3, {11{1'b0}}};
        wd3 = 32'h00000000;
        we3 = 0; muxcontrol = 0; alucontrol = 3'b010;
        #2;
        
        // OR of register 1 and register 2.
        ra1 = 5'b00001; ra2 = 5'b00010; wa3 = 5'b00000;
        instruction = {{6{1'b0}}, ra1, ra2, wa3, {11{1'b0}}};
        wd3 = 32'h00000000;
        we3 = 0; muxcontrol = 0; alucontrol = 3'b001;
        #2;
        
        // AND of register 1 and register 2.
        ra1 = 5'b00001; ra2 = 5'b00010; wa3 = 5'b00000;
        instruction = {{6{1'b0}}, ra1, ra2, wa3, {11{1'b0}}};
        wd3 = 32'h00000000;
        we3 = 0; muxcontrol = 0; alucontrol = 3'b000;
        #2;
        
        $finish;
    end
endmodule
