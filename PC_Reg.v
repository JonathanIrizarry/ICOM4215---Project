module PC_Register (
    input clk,
    input reset,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    reg le_pc = 1'b1;
	reg le_npc = 1'b1;
    // PC register logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset: Set all bits to 0
            pc_out <= 32'b0;
        end else if (le_pc) begin
            
            pc_out <= pc_in;
        end
    end

endmodule
