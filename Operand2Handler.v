module Operand2Handler(
    input [31:0] PB, // 32-bit input
    input [31:0] HI, // 32-bit input
    input [31:0] LO, // 32-bit input
    input [31:0] PC, // 32-bit input
    input [15:0] imm16, // 16-bit input
    input [2:0] Si, // 3-bit input
    output reg [31:0] N // 32-bit output
);

always @(*) begin
    case(Si)
        3'b000: N = PB;
        3'b001: N = HI;
        3'b010: N = LO;
        3'b011: N = PC;
        3'b100: N = {{16{imm16[15]}}, imm16};
        3'b101: N = {imm16,16'b0};
        default: N = 2'b00; 
    endcase
end

endmodule