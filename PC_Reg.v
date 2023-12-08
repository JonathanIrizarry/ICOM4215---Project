module PC_Register (
    input clk,
    input reset,
    input [31:0] pc_in,
	input le_pc,
    output reg [31:0] pc_out
);

    // PC register logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset: Set all bits to 0
            pc_out <= 32'b0;
			//$display("PC Reset - in = %d, out = %d, clk = %b, reset = %b", pc_in, pc_out, clk, reset);
        end else if (le_pc) begin
            
            pc_out <= pc_in;
			//$display("in = %d, out = %d, clk = %b, reset = %b", pc_in, pc_out, clk, reset);
        end
    end

endmodule
