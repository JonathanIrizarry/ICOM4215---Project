module plus4AdderForPCSignal( 
    output reg [8:0] result,
    input [8:0] input_value
);

always @* begin
    result = input_value + 8'b00000100;
end

endmodule