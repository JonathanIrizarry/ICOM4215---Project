module signExtenderTimes4imm16( 
    output reg [31:0] extended,
    input [25:0] extend
    );

    always @* begin
        extended = $signed(extend * 4);
    end
endmodule