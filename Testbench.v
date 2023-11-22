`include "Pipeline.v"
//`include "ControlUnit.v"

module SimplePipeline_TB;

  // Define parameters
  reg clk, reset, S;
  wire [31:0] test_instruction;
  wire [31:0] test_result;
  wire [31:0] pc_wire;
  wire [31:0] npc_wire;
  wire [14:0] control_wire;
  wire [31:0] instruction_wire;
  wire S_wire;



  // Instantiate Pipeline
  SimplePipeline dut (
    .clk(clk),
    .reset(reset),
    .instruction_reg(test_instruction),
    .result_out(test_result),
    .pc_reg(pc_wire),
    .npc_reg(npc_wire),
    .S(S),
    .control_output(control_wire)

  );

  // Instantiate PPU_Control_Unit
  // PPU_Control_Unit uut(
  //   .instruction(instruction_wire), // Connect instruction_wire to instruction in PPU_Control_Unit
  //   .control_output(control_wire),
  //   .S(S)
  // );
  
 always begin
		#2 clk = ~clk; // Invert the clock every 2 time unit
     //$display("Time %0t: Toggling clk to %b", $time, clk);
	end

  // Initial block for setup
  initial begin
    // Initialize signals
    clk = 1'b0;
    reset = 1'b1;
    S = 1'b0;
   

    // Apply reset
    #2 reset = 1'b0;


    // Apply S signal
    #38 S = 1'b1;

    // Simulate until time 48
    #8 $finish;
  end



// Inside your always block or procedural block where you want to display the keyword






    
    // Display the string
   




	// Clock generation
	


  // Display information at each clock cycle
  always @(posedge clk) begin


  

   
    if (test_instruction[31:26] == 6'b001001) begin
        $display("=========================================================================",
            "\n  KeyWord: ADDIU  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b",  test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    
        //str = "ADDIU";
    end else if (test_instruction[31:26] == 6'b100100) begin
        //str = "LBU";
        $display("=========================================================================",
            "\n  KeyWord: LBU  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b",  test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

    end else if (test_instruction[31:26] == 6'b000111) begin
       // str = "BGTZ";
        $display("=========================================================================",
            "\n  KeyWord: BGTZ  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

    end else if (test_instruction[31:26] == 6'b101000) begin
       // str = "SB";
        $display("=========================================================================",
            "\n  KeyWord: SB  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

    end else if (test_instruction[31:26] == 6'b000011) begin
        //str = "JAL";
        $display("=========================================================================",
            "\n  KeyWord: JAL  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

    end else if (test_instruction[31:26] == 6'b001111) begin
        //str = "LUI";
        $display("=========================================================================",
            "\n  KeyWord: LUI  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

    end else if (test_instruction[31:26] == 6'b000000) begin
        //str = "R";
        // $display("=========================================================================",
        //     "\n  KeyWord = %s  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

        
        if (test_instruction[5:0] == 6'b100011) begin
            //str = "SUBU";
            $display("=========================================================================",
            "\n  KeyWord: SUBU  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b",  test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

        end
       
    end




    // Print keyword, PC, nPC, and control signals
    // $display("=========================================================================",
    //         "\n  KeyWord = %s  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", str, test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    
    // Print control signals of EX, MEM, and WB stages
    // $display("EX: %b MEM: %b WB: %b", dut.alu_op_reg, dut.mem_enable_reg, dut.rf_enable_reg);
end

endmodule