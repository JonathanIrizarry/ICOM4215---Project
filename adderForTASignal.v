module adderForTASignal(
    output reg [31:0] sum,
    input [31:0] operandBig,
    input [7:0] operandSmall
);

always @* begin
    sum = operandBig + operandSmall;
end

endmodule
