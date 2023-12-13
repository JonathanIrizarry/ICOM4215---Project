module adderPCAndEight(
    output reg [8:0] sum,
    input [8:0] PC
);

always @* begin
    sum = PC + 8'b00001000;
end

endmodule