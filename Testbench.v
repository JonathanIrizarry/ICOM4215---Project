//`include "Pipeline.v"
//`include "ControlUnit.v"
//`include "SistemaControl.v"
//`include "InstructionMemory.v"
`include "ControlUnit.v"
`include "InstructionMemory.v"
`include "EX_Stage.v"
`include "ID_Stage.v"
`include "IFID_Stage.v"
`include "MEM_Stage.v"
`include "MUX.v"
`include "nPC_Reg.v"
`include "PC_Reg.v"
`include "WB_Stage.v"
module Pipeline_TB;

  // Define parameters
  reg clk, reset, S;
  wire [31:0] test_instruction;
  wire [31:0] test_result;
  wire [31:0] pc_wire_out;
  wire [31:0] pc_wire_in;
  wire [31:0] npc_wire_in;
  wire [31:0] npc_wire_out;
  wire [16:0] control_wire;
  wire [31:0] instructionMem_wire_in;
  wire [31:0] instructionMem_wire_out;
  wire [16:0] ControlSignal_wire;
  wire [16:0] mux_wire_in;
  wire [16:0] mux_wire_out;




  // Instantiate Pipeline
  // SistemaControl dut (
    // .clk(clk),
    // .reset(reset)
  // );


wire [31:0] adder_wire_out;
reg [8:0] address;
wire [31:0] DataOut;
wire [16:0] control_signals_wire;
wire [16:0] mux_out_wire;
wire [31:0] instruction_wire_out;
reg [7:0] data;
integer fi, fo, code, i; 
reg [2:0] alu_op_reg;
reg [31:0] mem_result;
reg [31:0] result_reg;
reg load_instr_reg;
reg [2:0] sourceOperand_3bit_reg;
reg rf_enable_reg;
wire ID_branch_instr;
wire ta_instr_reg;
reg mem_enable_reg;
reg mem_se_reg;
reg mem_rw_reg;
reg [1:0] mem_size_reg;
reg hi_enable_reg;
reg lo_enable_reg;
wire [16:0] ex_wire;



NPC_Register npc_instance(
    .clk(clk),
    .reset(reset),
    .npc_in(adder_wire_out),
    .npc_out(npc_wire_out)
);

Adder_4 adder_instance(
    .adder_in(npc_wire_out),
    .adder_out(adder_wire_out)
);

PC_Register pc_instance(
    .clk(clk),
    .reset(reset),
    .pc_in(npc_wire_out),
    .pc_out(pc_wire_out) //fix 
);

instr_mem imem(
    .DataOut(DataOut),
    .Address(pc_wire_out[8:0]),
    .instr(pc_wire_out)
);



	//Preload Instruction Memory
	initial begin
		fi = $fopen("input.txt","r");
		address = 9'b000000000;
		while (!$feof(fi)) begin
			code = $fscanf(fi, "%b", data);
			imem.Mem[address] = data;
			address = address + 1;
     // $display("instruction memory", imem.Mem[address]);
	end
	$fclose(fi);
	end


PPU_Control_Unit control_unit(
	.clk(clk),
    .instruction(instruction_wire_out),
    .control_signals(control_signals_wire)
  );    


mux mux_instance(
    .input_0(control_signals_wire),
    .S(S), // por ahora
    .mux_control_signals(mux_out_wire),
	.ID_branch_instr(ID_branch_instr)
);


IFID_Stage if_instance(
    .clk(clk),
    .reset(reset),
    .instruction_in(DataOut),
    .instruction_out(instruction_wire_out)
);

// ID_Stage id_instance(
    // .clk(clk),
    // .reset(reset),
	// .ta_instr_reg(ta_instr_reg),
    // .control_signals(control_signals_wire),
    // .control_signals_out(mux_out_wire)
// );

EX_Stage ex_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mux_out_wire),
    .control_signals_out(ex_wire)
);
// MEM_Stage mem_instance(
    // .clk(clk),
    // .reset(reset),
    // .control_signals(mux_out_wire),
    // .control_signals_out(mux_out_wire)
// );
// WB_Stage wb_instance(
    // .clk(clk),
    // .reset(reset),
    // .control_signals(mux_out_wire),
    // .control_signals_out(mux_out_wire)
// );



  
  initial begin
   
    clk <= 1'b0;
    reset <= 1'b1;
    S <= 1'b0;
    
    #3 reset = 1'b0;
   
    #37 S = 1'b1;

    
    #8 $finish;
  end

 always begin
		#2 clk = ~clk; // Invert the clock every 2 time unit
	end


// always @ (posedge clk) begin
// #1;
// 	$display("npc = %d, pc = %d, Instruction = %b, ctrl signals = %b, branch = %b \n", npc_wire_out, pc_wire_out, instruction_wire_out, control_signals_wire, ID_branch_instr);

//   $display(" Ex Stage,  control signlas = %b \n", ex_wire );

//   // $display("npc = %d, pc = %d, Instruction = %b, ctrl signals = %b, branch = %b \n", npc_wire_out, pc_wire_out, instruction_wire_out, control_signals_wire, ID_branch_instr);

//   // $display("npc = %d, pc = %d, Instruction = %b, ctrl signals = %b, branch = %b \n", npc_wire_out, pc_wire_out, instruction_wire_out, control_signals_wire, ID_branch_instr);

//   // $display("npc = %d, pc = %d, Instruction = %b, ctrl signals = %b, branch = %b \n", npc_wire_out, pc_wire_out, instruction_wire_out, control_signals_wire, ID_branch_instr);






// end 
	
 


  
  always @(posedge clk) begin
      // $display("=========================================================================",
            // "\n  KeyWord: ADDIU  ,Instruction = %b, PC = %d, nPC = %d, Control Signals = %b, Clk = %b, Reset = %b, S = %b",  instructionMem_wire_out, pc_wire_out, npc_wire_out, mux_wire_out, clk, reset, S);

  #1;
   
    if (instruction_wire_out[31:26] == 6'b001001) begin
        $display(" KeyWord: ADDIU, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n",  instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
        $display(" Ex Stage,  control signlas = %b \n", ex_wire );
    
        //str = "ADDIU";
    end else if (instruction_wire_out[31:26] == 6'b100100) begin
        //str = "LBU";
        $display(" KeyWord: LBU, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n",  instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
        $display(" Ex Stage,  control signlas = %b \n", ex_wire );

    end else if (instruction_wire_out[31:26] == 6'b000111) begin
       // str = "BGTZ";
        $display("KeyWord: BGTZ, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n", instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
        $display(" Ex Stage,  control signlas = %b \n", ex_wire );

    end else if (instruction_wire_out[31:26] == 6'b101000) begin
       // str = "SB";
        $display(" KeyWord: SB, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n", instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
        $display(" Ex Stage,  control signlas = %b \n", ex_wire );

    end else if (instruction_wire_out[31:26] == 6'b000011) begin
        //str = "JAL";
        $display("  KeyWord: JAL, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n", instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
        $display(" Ex Stage,  control signlas = %b \n", ex_wire );

    end else if (instruction_wire_out[31:26] == 6'b001111) begin
        //str = "LUI";
        $display("  KeyWord: LUI, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n", instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
        $display(" Ex Stage,  control signlas = %b \n", ex_wire );

    end else if (instruction_wire_out[31:26] == 6'b000000) begin
        //str = "R";
        // $display("=========================================================================",
        //     "\n  KeyWord = %s  ,Instruction = %b, PC = %d, nPC = %d, Control Signals = %b, Clk = %b, Reset = %b, S = %b", test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    

        
        if (instruction_wire_out[5:0] == 6'b100011) begin
           //str = "SUBU";
            $display(" KeyWord: SUBU, Instruction = %b, PC = %d, nPC = %d, Control Signals = %b \n",  instruction_wire_out, pc_wire_out, npc_wire_out, control_signals_wire);
            $display(" ,  control signlas = %b \n", );

        end
       
    end else if (instruction_wire_out == 32'b0) begin
         $display("KeyWord: NOP, Instruction = %b, PC = %d, nPC = %d \n", instruction_wire_out, pc_wire_out, npc_wire_out );

    end




    // Print keyword, PC, nPC, and control signals
    // $display("=========================================================================",
    //         "\n  KeyWord = %s  ,Instruction = %b, PC = %d, nPC = %d, Control Unit = %b, Clk = %b, Reset = %b, S = %b", str, test_instruction, pc_wire, npc_wire, control_wire, clk, reset, S);
    
    // Print control signals of EX, MEM, and WB stages
    // $display("EX: %b MEM: %b WB: %b", dut.alu_op_reg, dut.mem_enable_reg, dut.rf_enable_reg);
end

endmodule