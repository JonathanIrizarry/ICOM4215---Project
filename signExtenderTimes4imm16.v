module signExtenderTimes4imm16( 
    output reg signed [31:0] extended,
    input signed [15:0] extend
    );

    always @* begin
        extended = $signed(extend * 4);
    end
endmodule