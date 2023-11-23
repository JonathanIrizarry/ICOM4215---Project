module mux(
    input [16:0] input_0,
    input S,
    output reg [16:0] mux_control_signals

);

always @ (S) begin
    if (S==0) begin
        mux_control_signals <= input_0;
    end else begin 
        mux_control_signals = 17'b0;
    end
end

endmodule