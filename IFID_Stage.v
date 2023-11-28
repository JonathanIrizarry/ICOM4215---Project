module IFID_Stage (
    input clk,
    input reset,
    input wire [31:0] instruction_in,
    output reg [31:0] instruction_out,
	//input [16:0] control_signals,
	output reg ta_instr_reg
    //output reg [16:0] control_signals_out
);

    always @(posedge clk or posedge reset) begin
		if (reset) begin
				instruction_out <= 32'b0;
			end else begin
				instruction_out <= instruction_in;
    end
	end
endmodule