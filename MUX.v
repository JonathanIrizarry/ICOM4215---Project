module mux(
    input [16:0] input_0,
    input S,
    output reg [16:0] mux_control_signals,
	output reg ID_branch_instr
);

always @ (S, input_0) begin
    if (S == 1'b0) begin
        mux_control_signals <= input_0;
		//$display("mux = %b", mux_control_signals);
		//$display("test = %b", input_0);
    end else begin 
        mux_control_signals <= 17'b0;
		//$display("mux = %b", mux_control_signals);
    end
end

endmodule