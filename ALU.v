module ALU (
    input [3:0] Op,  // 4-bit opcode 
    input signed [31:0] A,  // Input A 32-bit
    input signed [31:0] B,  // Input B 32-bit 
    output reg signed [31:0] Out,  // Result 32-bit
    output reg Z,  // Zero flag
    output reg N  // Negative flag
);

always @(*) begin
    case (Op)
        4'b0000: // Addition
            Out = A + B;   
        4'b0001: // Subtraction
            Out = A - B;
        4'b0010: // AND
            Out = A & B;
        4'b0011: // OR
            Out = A | B;
        4'b0100: // XOR
            Out = A ^ B;
        4'b0101: // NOR
            Out = ~(A | B);
        4'b0110: // Shift Left Logical
            Out = B << A;
        4'b0111: // Shift Right Logical
            Out = B >> A;
        4'b1000: // Shift Right Arithmetic
            Out = B >>> A;
        4'b1001: 
            Out = (A < B) ? 1'b1 : 1'b0; 
        4'b1010:
            Out = A;
        4'b1011:
            Out = B;
        4'b1100:
            Out = B + 32'd8;
        default:
            Out = 32'b0;
    endcase

   
    if (Op == 4'b0000 || Op == 4'b0001 || Op == 4'b1001 || Op == 4'b1010 || Op == 4'b1011) begin
        Z = (Out == 32'b0) ? 1'b1 : 1'b0;
        N = (Out[31] == 1'b1) ? 1'b1 : 1'b0;
    end else begin
        Z = 1'b0;  
        N = 1'b0;  
    end
 
end

endmodule