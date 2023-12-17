module mux(
    input [21:0] input_0,
    input S,
    output reg [21:0] mux_control_signals
);

always @ (*) begin
    if (S == 1'b0) begin
        mux_control_signals <= input_0;
		//$display("mux = %b", mux_control_signals);
		//$display("test = %b", input_0);
    end else begin 
        mux_control_signals <= 22'b0;
		//$display("mux = %b", mux_control_signals);
    end
end

endmodule