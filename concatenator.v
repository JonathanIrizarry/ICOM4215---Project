module concatenator(
    output reg [31:0] concatenated_result,
    input [25:0] high_bits,
    input [31:28] low_bits
);

always @* begin
    concatenated_result = {high_bits,low_bits};
end

endmodule