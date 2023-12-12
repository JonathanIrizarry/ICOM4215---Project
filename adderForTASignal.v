module adderForTASignal(
    output reg [31:0] sum,
    input reg [31:0] operandBig,
    input reg [7:0] operandSmall
);

always @* begin
    sum = operandBig + operandSmall;
end

endmodule
