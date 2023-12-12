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
`include "ALU.v"
`include "Operand2Handler.v"
`include "register-file.v"
`include "ConditionHandler.v"
`include "hazardForwardingUnit.v"
`include "DataMemory.v"
`include "concatenator.v"
`include "signExtenderTimes4address26.v"
`include "signExtenderTimes4imm16.v"
`include "plus4AdderForPCSignal.v"
`include "adderForTASignal.v"
`include "adderPCAndEight.v"

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
	wire [2:0] SourceOperand_3bits;
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
  wire conditional_inconditional; //bit 21
  wire r31; //bit 20
  wire unconditional_Jump; //bit 19
  wire destination; //bit 18
  wire [25:0] address_26_out; // bit 25:0 de instruction 
  wire [8:0] PC_out; //bit8:0
  wire [25:21] rs_out; //bit 25:21
  wire [20:16] rt_out; //bit 20:16
  wire [15:0] imm16_out; //bit 15:0
  wire [31:26] opcode_out; //bit 31:26
  wire [15:11] rd_out;
  wire [8:0] mem_alu_out;
  wire [31:0] mem_pa_out;
  wire mem_load_instr_reg;
  wire mem_rf_enable_reg;
  wire [31:0] mem_pc8_out;
  
  //IDEX STAGE
  wire [31:0] targetAddress_in;
  wire [31:0] targetAddress_out;
  wire ID_hi;
  wire ID_lo;
  wire [4:0] EX_opcode;

  wire [31:0] Target_Address_outEX;
  wire HI_out_EX;
  wire Lo_out_EX;
  wire [31:0] PA_out_Ex;
  wire [31:0] PB_out_Ex;
  wire [8:0] PC_out_Ex;
  wire [15:0] imm16_out_Ex;
  wire [20:16] rt_out_Ex;
  wire [31:26] opcode_out_Ex;
  wire [15:11] rd_out_Ex;
  wire [15:11] rd_out_Mem;
  wire [15:11] rd_out_Wb;
  wire [31:0] pc_plus8_outEX;
  wire r31_mux_outEx;
  wire [31:0] N_ALU;
  wire Condition_handler_out;
  
  wire [1:0] hazardUnit_mux1;
  wire [1:0] hazardUnit_mux2;
  wire hazardUnit_control_mux;
  wire IFID_LE;
  wire PC_LE;
  
  wire [31:0] mux_PA_out;
  wire [31:0] mux_PB_out;

  wire [31:0] if_mux_out;
  wire logicBox_mux_out;
  
  //ALU 
  wire [31:0] alu_out;  // Result 32-bit
  wire alu_Z;  // Zero flag
  wire alu_N; // Negative flag
  
  
  //EXMEM Stage
  wire [31:0] dataMem_Out;
  wire [31:0] mux_Mem_Out;
  
  
  //MEMWB Stage
  wire [31:0] mux_WB_out;


//wire [4:0] WB_rd_out; this wire likely is not needed
//unclear amount of bits
wire [4:0] WB_rdrtr31mux_out;
//unclear amount of bits
wire WB_RF_enable_out;
//unclear amount of bits, what is this even called?
wire [31:0] WB_out_MemMux_out;

//RF outputs
wire [31:0] pa;
wire [31:0] pb;

//concatenator wires
wire[8:0] pcPlusFourLastBits;
wire[31:0] fourTimesAddressTwentySix;
wire[31:0] concatenated_result_out;

//adderForTASignal wires
wire[31:0] fourTimesimmSixteen;
wire[8:0] pcPlusFour;
wire[31:0] addedPCFourAndFourTimesimmSixteen;

//adderPCAndEight wires
wire[8:0] sumBetweenPCandEight;
//wire[8:0] PC_out; already added

//signExtenderTimes4imm16 wires
//wire [15:0] imm16_out; already declared

//signExtenderTimes4address26 wires
// wire [25:0] address_26_out; already declared

//plus4AdderForPCSignalTop wires
//wire [8:0] PC_out; already declared

//plus4AdderForPCSignalBottom wires
//wire [8:0] PC_out; already declared

adderPCAndEight adderPCAndEight(
.sum(sumBetweenPCandEight),
.PC(PC_out)
);

concatenator concatenator(
.high_bits(fourTimesAddressTwentySix),
.low_bits(pcPlusFourLastBits),
.concatenated_result(concatenated_result_out)
);

adderForTASignal adderForTASignal(
.sum(addedPCFourAndFourTimesimmSixteen),
.operandBig(fourTimesimmSixteen),
.operandSmall(pcPlusFour)
);

signExtenderTimes4imm16 signExtenderTimes4imm16(
.extended(fourTimesimmSixteen),
.extend(imm16_out)
);

signExtenderTimes4address26 signExtenderTimes4address26(
.extended(fourTimesAddressTwentySix),
.extend(address_26_out)
);

plus4AdderForPCSignal plus4AdderForPCSignalTop(
.result(pcPlusFour),
.input_value(PC_out)
);

plus4AdderForPCSignal plus4AdderForPCSignalBottom(
.result(pcPlusFourLastBits),
.input_value(PC_out)
);

register_file register_file_instance(
.RA(rs_out),
.RB(rt_out),
//.RW(WB_rd_out),
.RW(WB_rdrtr31mux_out),
.LE(WB_RF_enable_out),
.PW(WB_out_MemMux_out),
.PA(pa),
.PB(pb)
);

NPC_Register npc_instance(
    .clk(clk),
    .reset(reset),
    .npc_in(adder_wire_out),
	  .le_npc(PC_LE),
    .npc_out(npc_wire_out)
);

Adder_4 adder_instance(
    .adder_in(pc_wire_in),
    .adder_out(adder_wire_out)
);

PC_Register pc_instance(
    .clk(clk),
    .reset(reset),
    .pc_in(pc_wire_in),
	  .le_pc(PC_LE),
    .pc_out(pc_wire_out)  
);

instr_mem imem(
    .DataOut(DataOut),
    .Address(pc_wire_out[8:0]),
    .instr(pc_wire_out)
);

Operand2Handler operand(
  .PB(PB_out_Ex),
  .HI(HI_out_EX),
  .LO(Lo_out_EX),
  .PC(PC_out_Ex),
  .imm16(imm16_out_Ex),
  .Si(ex_wire[17:15]),
  .N(N_ALU)// output going to B of ALU 
);

ALU alu_inst(
  .Op(alu_op_reg),
  .A(PA_out_Ex),
  .B(N_ALU),
  .Out(alu_out), 
  .Z(alu_Z), // zero 
  .N(alu_N) //negative
);

Condition_Handler condition_Instance(
  .B_instr(ex_wire[8]),
  .opcode(opcode_out_Ex),
  .flag(), //input 
  .rt(rt_out_Ex),
  .handler_Out(Condition_handler_out)
);


IF_Mux if_mux_inst(
  .EX_TA(targetAddress_out),
  .ID_TA(), 
  .rs(), //muxA output
  .TA_instruction(mux_out_wire[7]),
  .conditional_inconditional(mux_out_wire[21]),
  .mux_out(if_mux_out)
);

LogicBox logicBox_inst(
  .Handler_B_instr(Condition_handler_out),
  .unconditional_jump_signal(mux_out_wire[21]),
  .logicbox_out(logicBox_mux_out)
);


LogicBox_mux logicBox_muxInst(
   .logicbox_out(logicBox_mux_out),
   .IF_mux(if_mux_out),
   .nPC_input(npc_wire_out),
   .Logic_mux_output(pc_wire_in) 

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
    .S(hazardUnit_control_mux), 
    .mux_control_signals(mux_out_wire)
);


HazardForwardingUnit hazardUnit(
	.rs(rs_out),
	.rt(rt_out),
	.EX_load_instr(ID_load_instr_reg),
	.EX_RF_Enable(ID_rf_enable_reg),
	.MEM_RF_Enable(EX_rf_enable_reg),
	.WB_RF_Enable(MEM_rf_enable_reg),
	.rd_ex(rd_out_Ex),
	.rd_mem(rd_out_Mem),
	.rd_wb(rd_out_Wb),
	.mux1_select(hazardUnit_mux1),
	.mux2_select(hazardUnit_mux2),
	.control_select(hazardUnit_control_mux),
	.IFID_LE(IFID_LE),
	.PC_LE(PC_LE)
);

mux_4x1 mux_PA(
	.S(hazardUnit_mux1), //select
	.I0(mux_WB_out),
	.I1(mux_Mem_Out),
	.I2(alu_out),
	.I3(pa),
	.Y(mux_PA_out) //output
);

mux_4x1 mux_PB(
	.S(hazardUnit_mux2), //select
	.I0(mux_WB_out),
	.I1(mux_Mem_Out),
	.I2(alu_out),
	.I3(pb),
	.Y(mux_PB_out) //output
);


IFID_Stage if_instance(
    .clk(clk),
    .reset(reset),
	.le(IFID_LE),
	.logicbox(), // Falta output de Logicbox aqui
    .instruction_in(DataOut),
    .instruction_out(instruction_wire_out),
    .address_26(address_26_out),
    .PC(PC_out),
    .rs(rs_out),
    .rt(rt_out),
    .imm16(imm16_out),
    .opcode(opcode_out),
    .rd(rd_out)
);


IDEX_Stage ex_instance(
  .clk(clk),
  .reset(reset),
  .control_signals(mux_wire_out),
	.targetAddress_in(targetAddress_in),
	.ID_hi(ID_hi),
	.ID_lo(ID_lo),
	.ID_muxA(mux_PA_out),
	.ID_muxB(mux_PB_out), 
	.ID_PB(pb),
	.ID_imm16(imm16_out),
	.ID_opcode(opcode_out),
	.ID_PC(PC_out),
	.ID_rd(rd_out),
	.ID_rt(rt_out),
	.ID_r31(), // Falta Mux de R31
	.ID_PC8(sumBetweenPCandEight), // Falta Adder+8 para PC
  .control_signals_out(ex_wire),
	.alu_op_reg(alu_op_reg),
	.conditionHandler_opcode(opcode_out_Ex),
  .EX_branch_instr(EX_branch_instr),
  .load_instr_reg(ID_load_instr_reg),
  .rf_enable_reg(ID_rf_enable_reg),
  .SourceOperand_3bits(SourceOperand_3bits),
	.SourceOperand_Hi(HI_out_EX),
	.SourceOperand_Lo(Lo_out_EX),
	.SourceOperand_PB(PB_out_Ex),
	.alu_A(PA_out_Ex), 
	.EX_PC(PC_out_Ex),
	.EX_imm16(imm16_out_Ex),
	.EX_rd(rd_out_Ex),
	.EX_PC8(pc_plus8_outEX),
	.EX_rt(rt_out_Ex),
	.EX_R31(r31_mux_outEx),
	.targetAddress_out(targetAddress_out)
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
	.load_instr_reg(mem_load_instr_reg),
	.rf_enable_reg(mem_rf_enable_reg),
	.MEM_ALU_out(mem_alu_out),
	.MEM_PA_out(mem_pa_out),
	.MEM_PC8_out(mem_pc8_out),
	.MEM_rd_out(rd_out_Mem)
);

DataMemory dataMem(
	.DataOut(dataMem_Out),
	.Enable(mem_enable_reg),
	.ReadWrite(mem_rw_reg),
	.SE(mem_se_reg),
	.Size(mem_size_reg),
	.Address(mem_alu_out),
	.DataIn(mem_pa_out)
);

mux_4x1 mux_Mem(
    .S(mem_load_instr_reg), 
    .I0(mem_alu_out), 
	.I1(mem_pc8_out),
	.I2(dataMem_Out),
	.I3(),
	.Y(mux_Mem_Out)
);

MEMWB_Stage wb_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mem_wire),
    .control_signals_out(wb_wire),
	.mux_mem_in(mux_Mem_Out),
	.mux_wb_out(mux_WB_out),
	.rf_enable_reg(MEM_rf_enable_reg),
	.hi_enable_reg(hi_enable_reg),
	.lo_enable_reg(lo_enable_reg),
	.wb_rd_out(rd_out_Wb)
);


// 
  
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



 // Printing Data from each phase
 
 always @(posedge clk) begin
  
	if((instruction_wire_out == 32'b0 | instruction_wire_out == 32'bx) && reset == 1'b0) begin
		$display("\n Keyword: NOP, PC = %d, nPC = %d", pc_wire_out, npc_wire_out,
				"\n\n --- ID STAGE ---",
        "\n ID_conditional_unconditional = %b", control_signals_wire[21],
        "\n ID_r31 = %b", control_signals_wire[20],
        "\n ID_unconditional_jump = %b", control_signals_wire[19],
        "\n ID_destination = %b", control_signals_wire[18],
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
        "\n ID_conditional_unconditional = %b", control_signals_wire[21],
        "\n ID_r31 = %b", control_signals_wire[20],
        "\n ID_unconditional_jump = %b", control_signals_wire[19],
        "\n ID_destination = %b", control_signals_wire[18],
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