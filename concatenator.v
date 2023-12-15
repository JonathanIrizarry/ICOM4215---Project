module concatenator(
    output reg [31:0] concatenated_result,
    input [27:0] high_bits,
    input [31:28] low_bits
);

always @* begin
    concatenated_result = { low_bits, high_bits};
end

endmodule