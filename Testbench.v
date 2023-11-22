`include "Pipeline.v"
module SimplePipeline_TB;

  // Define parameters
  reg clk, reset, S;
  reg [31:0] test_instruction,instruction;
  wire [31:0] test_result;
  wire [31:0] pc_wire;
  wire [31:0] npc_wire;

  // Instantiate Pipeline
  SimplePipeline dut (
    .clk(clk),
    .reset(reset),
    .instruction_in(test_instruction),
    .result_out(test_result)
  );
  
  
 	// Clock generation
	always begin
		#2 clk = ~clk; // Invert the clock every 2 time unit
	end

  // Initial block for setup
  initial begin
    // Initialize signals
    clk = 1'b0;
    reset = 1'b1;
    S = 1'b0;
    test_instruction = 32'b00100100000001010000000000000000; // Example: ADDIU instruction

    // Apply reset
    #2 reset = 1'b0;


    // Apply S signal
    #40 S = 1'b1;

    // Simulate until time 48
    #48 $finish;
  end

  // Display information at each clock cycle
  always @(posedge clk) begin
    // Print keyword, PC, nPC, and control signals
    //$display(" PC=%0d nPC=%0d Control Signals=%b",  pc_reg, npc_reg, PPU_Control_Unit.control_output);
	
	
    // Print control signals of EX, MEM, and WB stages
    //$display("EX: %b MEM: %b WB: %b", dut.alu_op_reg, dut.mem_enable_reg, dut.rf_enable_reg);
  end

endmodule