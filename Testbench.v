//`include "Pipeline.v"
//`include "ControlUnit.v"
//`include "SistemaControl.v"
//`include "InstructionMemory.v"
`include "ControlUnit.v"
`include "InstructionMemory.v"
`include "IDEX_Stage.v"
`include "IFID_Stage.v"
`include "EXMEM_Stage.v"
`include "MUX.v"
`include "nPC_Reg.v"
`include "PC_Reg.v"
`include "MEMWB_Stage.v"
module Pipeline_TB;

  // Define parameters
	reg clk, reset, S;
	wire [31:0] test_instruction;
	wire [31:0] test_result;
	wire [31:0] pc_wire_out;
	wire [31:0] pc_wire_in;
	wire [31:0] npc_wire_in;
	wire [31:0] npc_wire_out;
	wire [21:0] control_wire;
	wire [31:0] instructionMem_wire_in;
	wire [31:0] instructionMem_wire_out;
	wire [21:0] ControlSignal_wire;
	wire [21:0] mux_wire_in;
	wire [21:0] mux_wire_out;
	wire [31:0] adder_wire_out;
	reg [8:0] address;
	wire [31:0] DataOut;
	wire [21:0] control_signals_wire;
	wire [21:0] mux_out_wire;
	wire [31:0] instruction_wire_out;
	reg [7:0] data;
	integer fi, fo, code, i; 
	wire [3:0] alu_op_reg;
	reg [31:0] mem_result;
	reg [31:0] result_reg;
	reg [2:0] sourceOperand_3bit_reg;
	wire ID_branch_instr;
	wire ta_instr_reg;
	wire EX_branch_instr;
	wire ID_load_instr_reg;
	wire ID_rf_enable_reg;
	wire SourceOperand_3bits;
	wire mem_enable_reg;
	wire mem_se_reg;
	wire mem_rw_reg;
	wire [1:0] mem_size_reg;
	wire hi_enable_reg;
	wire lo_enable_reg;
	wire [21:0] ex_wire;
	wire [21:0] mem_wire;
	wire [21:0] wb_wire;
	wire EX_load_instr_reg;
	wire EX_rf_enable_reg;
	wire MEM_rf_enable_reg;



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
    .pc_out(pc_wire_out)  
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
			//$display("instruction memory = %b", imem.Mem[address]);
			address = address + 1;
	end
	$fclose(fi);
	end


PPU_Control_Unit control_unit(
    .instruction(instruction_wire_out),
    .control_signals(control_signals_wire)
  );    


mux mux_instance(
    .input_0(control_signals_wire),
    .S(S), 
    .mux_control_signals(mux_out_wire)
);


IFID_Stage if_instance(
    .clk(clk),
    .reset(reset),
    .instruction_in(DataOut),
    .instruction_out(instruction_wire_out)
);


IDEX_Stage ex_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mux_out_wire),
    .control_signals_out(ex_wire),
	.alu_op_reg(alu_op_reg),
	.branch_instr(EX_branch_instr),
	.load_instr_reg(ID_load_instr_reg),
	.rf_enable_reg(ID_rf_enable_reg),
	.SourceOperand_3bits(SourceOperand_3bits)
);

EXMEM_Stage mem_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(ex_wire),
    .control_signals_out(mem_wire),
	.mem_size_reg(mem_size_reg),
	.mem_se_reg(mem_se_reg),
	.mem_rw_reg(mem_rw_reg),
	.mem_enable_reg(mem_enable_reg),
	.load_instr_reg(EX_load_instr_reg),
	.rf_enable_reg(EX_rf_enable_reg)
);

MEMWB_Stage wb_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mem_wire),
    .control_signals_out(wb_wire),
	.rf_enable_reg(MEM_rf_enable_reg),
	.hi_enable_reg(hi_enable_reg),
	.lo_enable_reg(lo_enable_reg)
);



  
  initial begin
   
    clk <= 1'b0;
    reset <= 1'b1;
    S <= 1'b0;
    
    #3 reset = 1'b0;
   
    #37 S = 1'b1;

    
    #8 $finish;
  end

//  always begin
// 		#2 clk = ~clk; // Invert the clock every 2 time unit
// 	end
initial repeat(200) begin
    #2 clk = ~clk;
end


 // Printing Data from each phase
 
  always @(posedge clk) begin
  
	if((instruction_wire_out == 32'b0 | instruction_wire_out == 32'bx) && reset == 1'b0) begin
		$display("\n Keyword: NOP, PC = %d, nPC = %d", pc_wire_out, npc_wire_out,
				"\n\n --- ID STAGE ---",
				"\n ID_SourceOperand_3bits = %b", control_signals_wire[17:15],
				"\n ID_ALU_OP = %b", control_signals_wire[14:11],
				"\n ID_Load_Instr = %b", control_signals_wire[10],
				"\n ID_RF_Enable = %b", control_signals_wire[9],
				"\n ID_B_Instr = %b", control_signals_wire[8],
				"\n ID_TA_Instr = %b", control_signals_wire[7],
				"\n ID_MEM_Size = %b", control_signals_wire[6:5],
				"\n ID_MEM_RW = %b", control_signals_wire[4],
				"\n ID_MEM_SE = %b", control_signals_wire[3],
				"\n ID_Enable_HI = %b", control_signals_wire[2],
				"\n ID_Enable_LO = %b", control_signals_wire[1],
				"\n ID_MEM_Enable = %b", control_signals_wire[0],
				"\n\n --- EX STAGE ---",
				"\n EX_SourceOperand_3bits = %b", ex_wire[17:15],
				"\n EX_ALU_OP = %b", ex_wire[14:11],
				"\n EX_Load_Instr = %b", ex_wire[10],
				"\n EX_RF_Enable = %b", ex_wire[9],
				"\n EX_B_Instr = %b", ex_wire[8],
				"\n EX_MEM_Size = %b", ex_wire[6:5],
				"\n EX_MEM_RW = %b", ex_wire[4],
				"\n EX_MEM_SE = %b", ex_wire[3],
				"\n EX_Enable_HI = %b", ex_wire[2],
				"\n EX_Enable_LO = %b", ex_wire[1],
				"\n EX_MEM_Enable = %b", ex_wire[0],
				"\n\n --- MEM STAGE ---",
				"\n MEM_Load_Instr = %b", mem_wire[10],
				"\n MEM_RF_Enable = %b", mem_wire[9],
				"\n MEM_MEM_Size = %b", mem_wire[6:5],
				"\n MEM_MEM_RW = %b", mem_wire[4],
				"\n MEM_MEM_SE = %b", mem_wire[3],
				"\n MEM_Enable_HI = %b", mem_wire[2],
				"\n MEM_Enable_LO = %b", mem_wire[1],
				"\n MEM_MEM_Enable = %b", mem_wire[0],
				"\n\n --- WB STAGE ---",
				"\n WB_RF_Enable = %b", wb_wire[9],
				"\n WB_Enable_HI = %b", wb_wire[2],
				"\n WB_Enable_LO = %b", wb_wire[1]
		);
	end else if(reset == 1'b0) begin
	
		case (instruction_wire_out[31:26])
		
		// ADDIU
		6'b001001: begin
			$display("\n Keyword: ADDIU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
  
		// LBU
		6'b100100: begin
			$display("\n Keyword: LBU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
			
		// BGTZ
		6'b000111: begin
			$display("\n Keyword: LBGTZ, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
			
		// SB
		6'b101000: begin
			$display("\n Keyword: SB, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
			
		// JAL
		6'b000011: begin
			$display("\n Keyword: JAL, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
			
		// LUI
		6'b001111: begin
			$display("\n Keyword: LUI, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
			
		// R
		6'b000000: begin
			// JR
			if(instruction_wire_out[5:0] == 6'b001000) begin
				$display("\n Keyword: JR, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			
			// SUBU
			end else if(instruction_wire_out[5:0] == 6'b100011) begin
				$display("\n Keyword: SUBU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			end
			end
		endcase
		$display("\n\n --- ID STAGE ---",
				"\n ID_SourceOperand_3bits = %b", control_signals_wire[17:15],
				"\n ID_ALU_OP = %b", control_signals_wire[14:11],
				"\n ID_Load_Instr = %b", control_signals_wire[10],
				"\n ID_RF_Enable = %b", control_signals_wire[9],
				"\n ID_B_Instr = %b", control_signals_wire[8],
				"\n ID_TA_Instr = %b", control_signals_wire[7],
				"\n ID_MEM_Size = %b", control_signals_wire[6:5],
				"\n ID_MEM_RW = %b", control_signals_wire[4],
				"\n ID_MEM_SE = %b", control_signals_wire[3],
				"\n ID_Enable_HI = %b", control_signals_wire[2],
				"\n ID_Enable_LO = %b", control_signals_wire[1],
				"\n ID_MEM_Enable = %b", control_signals_wire[0],
				"\n\n --- EX STAGE ---",
				"\n EX_SourceOperand_3bits = %b", ex_wire[17:15],
				"\n EX_ALU_OP = %b", ex_wire[14:11],
				"\n EX_Load_Instr = %b", ex_wire[10],
				"\n EX_RF_Enable = %b", ex_wire[9],
				"\n EX_B_Instr = %b", ex_wire[8],
				"\n EX_MEM_Size = %b", ex_wire[6:5],
				"\n EX_MEM_RW = %b", ex_wire[4],
				"\n EX_MEM_SE = %b", ex_wire[3],
				"\n EX_Enable_HI = %b", ex_wire[2],
				"\n EX_Enable_LO = %b", ex_wire[1],
				"\n EX_MEM_Enable = %b", ex_wire[0],
				"\n\n --- MEM STAGE ---",
				"\n MEM_Load_Instr = %b", mem_wire[10],
				"\n MEM_RF_Enable = %b", mem_wire[9],
				"\n MEM_MEM_Size = %b", mem_wire[6:5],
				"\n MEM_MEM_RW = %b", mem_wire[4],
				"\n MEM_MEM_SE = %b", mem_wire[3],
				"\n MEM_Enable_HI = %b", mem_wire[2],
				"\n MEM_Enable_LO = %b", mem_wire[1],
				"\n MEM_MEM_Enable = %b", mem_wire[0],
				"\n\n --- WB STAGE ---",
				"\n WB_RF_Enable = %b", wb_wire[9],
				"\n WB_Enable_HI = %b", wb_wire[2],
				"\n WB_Enable_LO = %b", wb_wire[1]
		);
	end
end

endmodule