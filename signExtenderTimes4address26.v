module signExtenderTimes4address26( 
    output reg [27:0] extended,
    input [25:0] extend
    );

    always @* begin
        extended = $signed(extend * 4);
    end
endmodule