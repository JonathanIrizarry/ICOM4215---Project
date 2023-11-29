module IFID_Stage (
    input clk,
    input reset,
    input wire [31:0] instruction_in,
    output reg [31:0] instruction_out,
	//input [16:0] control_signals,
	//output reg ta_instr_reg
    output reg [25:0] address_26, // bit 25:0 de instruction 
    output reg [8:0] PC, //bit8:0
    output reg [25:21] rs, //bit 25:21
    output reg [20:16] rt, //bit 20:16
    output reg [15:0] imm16, //bit 15:0
    output reg [31:26] opcode, //bit 31:26
    output reg [15:11] rd //bit 15:11
    //output reg [16:0] control_signals_out
);

    always @(posedge clk or posedge reset) begin
		if (reset) begin
				instruction_out <= 32'b0;
			end else begin
				instruction_out <= instruction_in;
                address_26 <= instruction_in[25:0];
                PC <= instruction_in[8:0];
                rs <= instruction_in[25:21];
                rt <= instruction_in[20:16];
                imm16 <= instruction_in[15:0];
                opcode <= instruction_in[31:26];
                rd <= instruction_in[15:11];
    end
	end
endmodule