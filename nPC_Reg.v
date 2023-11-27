module NPC_Register (
    input clk,
    input reset,
    input [31:0] npc_in,
    output reg [31:0] npc_out
);
    reg le_pc = 1'b1;
	reg le_npc = 1'b1;
    // NPC register logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset: Set all bits to 4
            npc_out <= 32'b00000000000000000000000000000100;
        end else if (le_npc) begin
            // Load enable: Update NPC register with input value
            npc_out <= npc_in;
			//$display("in = %b, out %b", npc_in, npc_out);
        end
    end

endmodule


module Adder_4 (
    input wire [31:0] adder_in,
    output reg [31:0] adder_out
);

    // Adder logic: Add 4 to npc_out
    always @(*) begin
       adder_out = adder_in + 4;
    end

endmodule
