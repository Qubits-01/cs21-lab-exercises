module alu(input  logic [31:0] a, b,
           input  logic [2:0]  alucontrol,
           input  logic [4:0]  shamt,
           output logic [31:0] result,
           output logic        zero, gt);
  
  logic [31:0] condinvb, sum, temp;

  assign condinvb = alucontrol[2] ? ~b : b;
  assign sum = a + condinvb + alucontrol[2];
 
  always_comb begin
    case (alucontrol)
      3'b000: result = a & b;                               // and
      3'b001: result = a | b;                               // or (ori)
      3'b010: result = sum;                                 // add
      3'b110: result = sum;                                 // subtract (similar to sum; for beq, bgt)
      3'b111: result = sum[31];                             // slt (slti)
      3'b011: result = b;                                   // li
      3'b100: begin                                         // sra
        temp = b;                                        
        for (int i = 0; i < shamt; i = i + 1)
            temp = {b[31], temp[31:1]};
        result = temp;
      end
      3'b101: result = {a[31:28], b[27:24], a[23:20], b[19:16], a[15:12], b[11:8], a[7:4], b[3:0]};     // riffle                           
    endcase
  end

  assign zero = (result == 32'b0);
  assign gt = (a > b);
endmodule
