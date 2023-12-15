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
`include "decoders.v"

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
  wire [8:0] mem_pc8_out; //changed from 31:0 to 8:0
  
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
  wire [8:0] pc_plus8_outEX; //changed from 31:0 to 8:0
  wire [4:0] r31_mux_outEx;
  wire [31:0] N_ALU;
  wire Condition_handler_out;
  wire [4:0] mux_out_ID_r31;
  
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
  wire [4:0] r31_mux_outMem;
  
  
  //MEMWB Stage
  wire [31:0] mux_WB_out;
  wire [4:0] r31_mux_outWb;


//wire [4:0] WB_rd_out; this wire likely is not needed
//unclear amount of bits
wire [4:0] WB_rdrtr31mux_out;
//unclear amount of bits
wire WB_RF_enable_out;
//unclear amount of bits, what is this even called?
//wire [31:0] mux_WB_out;

//RF outputs
wire [31:0] pa;
wire [31:0] pb;

//concatenator wires
wire[8:0] pcPlusFourLastBits;
wire[27:0] fourTimesAddressTwentySix;
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

 wire [31:0] E;
  wire [31:0] Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, 
  Q16, Q17, Q18, Q19, Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29, Q30, Q31;




// -------------------------------------------------------------------------

adderPCAndEight adderPCAndEight(
.sum(sumBetweenPCandEight),
.PC(PC_out)
);

concatenator concatenator(
.high_bits(fourTimesAddressTwentySix),
.low_bits(pcPlusFourLastBits[8:5]),
.concatenated_result(concatenated_result_out)
);

adderForTASignal adderForTASignal(
.sum(addedPCFourAndFourTimesimmSixteen),
.operandBig(fourTimesimmSixteen),
.operandSmall(pcPlusFour)
);

signExtenderTimes4imm16 signExtenderTimes4imm16inbst(
.extended(fourTimesimmSixteen),
.extend(imm16_out)
);

signExtenderTimes4address26 signExtenderTimes4address26inst(
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

// register_file register_file_instance(
// .PA(pa), //out
// .PB(pb), //out 
// .PW(mux_WB_out), //in
// .RW(rd_out_Wb), //in 
// .RA(rs_out), //in
// .RB(rt_out), //in 
// .LE(WB_RF_enable_out) ///in
// );


 
 
  // Binary Decoder instantiation
binaryDecoder bdecoder (
  .E(E), //out
  .C(r31_mux_outWb), //in
  .RF(MEM_rf_enable_reg) //in
);


// Register instances instantiation
register_32bit R0 (.Q(Q0), .D(mux_WB_out), .clk(clk), .Ld(E[0]));
register_32bit R1 (.Q(Q1), .D(mux_WB_out), .clk(clk), .Ld(E[1]));
register_32bit R2 (.Q(Q2), .D(mux_WB_out), .clk(clk), .Ld(E[2]));
register_32bit R3 (.Q(Q3), .D(mux_WB_out), .clk(clk), .Ld(E[3]));
register_32bit R4 (.Q(Q4), .D(mux_WB_out), .clk(clk), .Ld(E[4]));
register_32bit R5 (.Q(Q5), .D(mux_WB_out), .clk(clk), .Ld(E[5]));
register_32bit R6 (.Q(Q6), .D(mux_WB_out), .clk(clk), .Ld(E[6]));
register_32bit R7 (.Q(Q7), .D(mux_WB_out), .clk(clk), .Ld(E[7]));
register_32bit R8 (.Q(Q8), .D(mux_WB_out), .clk(clk), .Ld(E[8]));
register_32bit R9 (.Q(Q9), .D(mux_WB_out), .clk(clk), .Ld(E[9]));
register_32bit R10 (.Q(Q10), .D(mux_WB_out), .clk(clk), .Ld(E[10]));
register_32bit R11 (.Q(Q11), .D(mux_WB_out), .clk(clk), .Ld(E[11]));
register_32bit R12 (.Q(Q12), .D(mux_WB_out), .clk(clk), .Ld(E[12]));
register_32bit R13 (.Q(Q13), .D(mux_WB_out), .clk(clk), .Ld(E[13]));
register_32bit R14 (.Q(Q14), .D(mux_WB_out), .clk(clk), .Ld(E[14]));
register_32bit R15 (.Q(Q15), .D(mux_WB_out), .clk(clk), .Ld(E[15]));
register_32bit R16 (.Q(Q16), .D(mux_WB_out), .clk(clk), .Ld(E[16]));
register_32bit R17 (.Q(Q17), .D(mux_WB_out), .clk(clk), .Ld(E[17]));
register_32bit R18 (.Q(Q18), .D(mux_WB_out), .clk(clk), .Ld(E[18]));
register_32bit R19 (.Q(Q19), .D(mux_WB_out), .clk(clk), .Ld(E[19]));
register_32bit R20 (.Q(Q20), .D(mux_WB_out), .clk(clk), .Ld(E[20]));
register_32bit R21 (.Q(Q21), .D(mux_WB_out), .clk(clk), .Ld(E[21]));
register_32bit R22 (.Q(Q22), .D(mux_WB_out), .clk(clk), .Ld(E[22]));
register_32bit R23 (.Q(Q23), .D(mux_WB_out), .clk(clk), .Ld(E[23]));
register_32bit R24 (.Q(Q24), .D(mux_WB_out), .clk(clk), .Ld(E[24]));
register_32bit R25 (.Q(Q25), .D(mux_WB_out), .clk(clk), .Ld(E[25]));
register_32bit R26 (.Q(Q26), .D(mux_WB_out), .clk(clk), .Ld(E[26]));
register_32bit R27 (.Q(Q27), .D(mux_WB_out), .clk(clk), .Ld(E[27]));
register_32bit R28 (.Q(Q28), .D(mux_WB_out), .clk(clk), .Ld(E[28]));
register_32bit R29 (.Q(Q29), .D(mux_WB_out), .clk(clk), .Ld(E[29]));
register_32bit R30 (.Q(Q30), .D(mux_WB_out), .clk(clk), .Ld(E[30]));
register_32bit R31 (.Q(Q31), .D(mux_WB_out), .clk(clk), .Ld(E[31]));






// Multiplexer for PA register instantiation
mux_32bit mux_32x1A (
  .Y(pa), //out
  .S(rs_out), // input
  .R0(32'b0), //32'b0 
  .R1(Q1),
  .R2(Q2),
  .R3(Q3),
  .R4(Q4),
  .R5(Q5),
  .R6(Q6),
  .R7(Q7),
  .R8(Q8),
  .R9(Q9),
  .R10(Q10),
  .R11(Q11),
  .R12(Q12),
  .R13(Q13),
  .R14(Q14),
  .R15(Q15),
  .R16(Q16),
  .R17(Q17),
  .R18(Q18),
  .R19(Q19),
  .R20(Q20),
  .R21(Q21),
  .R22(Q22),
  .R23(Q23),
  .R24(Q24),
  .R25(Q25),
  .R26(Q26),
  .R27(Q27),
  .R28(Q28),
  .R29(Q29),
  .R30(Q30),
  .R31(Q31)
);

// Multiplexer for PB register instantiation
mux_32bit mux_32x1B (
  .Y(pb),
  .S(rt_out),
  .R0(32'b0),
  .R1(Q1),
  .R2(Q2),
  .R3(Q3),
  .R4(Q4),
  .R5(Q5),
  .R6(Q6),
  .R7(Q7),
  .R8(Q8),
  .R9(Q9),
  .R10(Q10),
  .R11(Q11),
  .R12(Q12),
  .R13(Q13),
  .R14(Q14),
  .R15(Q15),
  .R16(Q16),
  .R17(Q17),
  .R18(Q18),
  .R19(Q19),
  .R20(Q20),
  .R21(Q21),
  .R22(Q22),
  .R23(Q23),
  .R24(Q24),
  .R25(Q25),
  .R26(Q26),
  .R27(Q27),
  .R28(Q28),
  .R29(Q29),
  .R30(Q30),
  .R31(Q31)
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
  .ID_TA(targetAddress_in), 
  .rs(mux_PA_out), //muxA output
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

TargetAddressMux addressMux(
  .concatenation(concatenated_result_out),
  .PC4_imm16(addedPCFourAndFourTimesimmSixteen),
  .conditional_inconditional(mux_out_wire[21]),
  .address(targetAddress_in)
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
    .S(/*hazardUnit_control_mux*/ 1'b0), 
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

mux_4x1 mux_r31(
  .Y(mux_out_ID_r31), 
	.S({mux_out_wire[20], mux_out_wire[18]}), //select
	.I0(rt_out),
	.I1(rd_out),
	.I2(),
	.I3(5'b11111)
	//output
);


mux_4x1 mux_PA(
  .Y(mux_PA_out),
	.S(hazardUnit_mux1), //select
	.I0(mux_WB_out),
	.I1(mux_Mem_Out),
	.I2(alu_out),
	.I3(pa)
	 //output
);

mux_4x1 mux_PB(
  .Y(mux_PB_out),
	.S(hazardUnit_mux2), //select
	.I0(mux_WB_out),
	.I1(mux_Mem_Out),
	.I2(alu_out),
	.I3(pb)
	 //output
);


IFID_Stage if_instance(
    .clk(clk),
    .reset(reset),
	  .le(IFID_LE),
    .input_pc(pc_wire_out[8:0]),
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
  .control_signals(mux_out_wire),
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
	.ID_r31(mux_out_ID_r31), // Falta Mux de R31
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
	.EX_R31(r31_mux_outEx),
    .control_signals(ex_wire),
    .control_signals_out(mem_wire),
	.mem_size_reg(mem_size_reg),
	.mem_se_reg(mem_se_reg),
	.mem_rw_reg(mem_rw_reg),
	.mem_enable_reg(mem_enable_reg),
	.load_instr_reg(mem_load_instr_reg),
	.rf_enable_reg(mem_rf_enable_reg),
	.EX_PC8(pc_plus8_outEX),
	.MEM_ALU_out(mem_alu_out),
	.MEM_PA_out(mem_pa_out),
	.MEM_PC8_out(mem_pc8_out),
	.MEM_rd_out(rd_out_Mem),
	.MEM_R31_out(r31_mux_outMem)
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


	//Preload Data Memory
	initial begin
		fi = $fopen("input.txt","r");
		address = 9'b000000000;
		while (!$feof(fi)) begin
			code = $fscanf(fi, "%b", data);
      dataMem.Mem[address] = data;
			address = address + 1;
	end
	$fclose(fi);
	end

mux_4x1 mux_Mem(
  .Y(mux_Mem_Out),
    .S(mem_load_instr_reg), 
    .I0(mem_alu_out), 
	.I1(mem_pc8_out), //replacing with input PC8
	//.PC8(mem_pc8_out),
	.I2(dataMem_Out),
	.I3()
	
);

MEMWB_Stage wb_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mem_wire),
    .control_signals_out(wb_wire),
	.mem_r31_in(r31_mux_outMem),//
	.mux_mem_in(mux_Mem_Out),//
	.mux_wb_out(mux_WB_out),//
	.rf_enable_reg(MEM_rf_enable_reg),
	.hi_enable_reg(hi_enable_reg),
	.lo_enable_reg(lo_enable_reg),
	.wb_rd_out(rd_out_Wb),//
	.wb_r31_out(r31_mux_outWb)//
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

	initial begin
		$monitor("\n\n\nPC: %d\n---------------------------------\
			\nAddress: %d\n--------------------------------------\
			\nR5: %d | R6: %d\
			\nR16: %d | R17: %d\
			\nR18: %d\ | Instruction: %b\
			\n--------------------------------------------------",
			pc_wire_out,
			rt_out,
			Q5, Q6, Q16, Q17, Q18,instruction_wire_out);

// $monitor("\n\n\nPC: %d\n---------------------------------\
//         \nAddress: %b\n--------------------------------------\
//         \nR0: %d | R1: %d | R2: %d | R3: %d\
//         \nR4: %d | R5: %d | R6: %d | R7: %d\
//         \nR8: %d | R9: %d | R10: %d | R11: %d\
//         \nR12: %d | R13: %d | R14: %d | R15: %d\
//         \nR16: %d | R17: %d | R18: %d | R19: %d\
//         \nR20: %d | R21: %d | R22: %d | R23: %d\
//         \nR24: %d | R25: %d | R26: %d | R27: %d\
//         \nR28: %d | R29: %d | R30: %d | R31: %d\
//         \n Edecoder: %b | PW: %b | C: %b | RF: %b\
//         \n--------------------------------------------------",
//         pc_wire_out,
//         rt_out,
//         Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9,
//         Q10, Q11, Q12, Q13, Q14, Q15, Q16, Q17, Q18, Q19,
//         Q20, Q21, Q22, Q23, Q24, Q25, Q26, Q27, Q28, Q29,
//         Q30, Q31, E, mux_WB_out, r31_mux_outWb , MEM_rf_enable_reg );


 

  // $monitor("\n\n\nLogicBoxMux: %d\n---------------------------------\
  //           \n EXTA: %d\n---------------------------------\
  //            \nID_TA: %d\n---------------------------------\
  //         \nrs: %d\n---------------------------------\
  //       \n IFMUX: %d | logic box out: %b \
  //       \n--------------------------------------------------",
  //        pc_wire_in,
  //       targetAddress_out, targetAddress_in, mux_PA_out , if_mux_out , logicBox_mux_out
                           //     );




	end


 // Printing Data from each phase
 
 // always @(posedge clk) begin

	
  
		// case (instruction_wire_out[31:26])
		
		// // ADDIU
		// 6'b001001: begin
			// $display("\n Keyword: ADDIU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
  
		// // LBU
		// 6'b100100: begin
			// $display("\n Keyword: LBU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			
		// // BGTZ
		// 6'b000111: begin
			// $display("\n Keyword: BGTZ, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			
		// // SB
		// 6'b101000: begin
			// $display("\n Keyword: SB, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			
		// // JAL
		// 6'b000011: begin
			// $display("\n Keyword: JAL, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			
		// // LUI
		// 6'b001111: begin
			// $display("\n Keyword: LUI, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			
		// // B
		// 6'b000100: begin
			// $display("\n Keyword: B, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end

		// // I
		// 6'b000001: begin
			// // BGEZ
			// if(instruction_wire_out[20:16] == 5'b00001) begin
				// $display("\n Keyword: BGEZ, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			// end
		
		// // R
		// 6'b000000: begin
			// // JR
			// if(instruction_wire_out[5:0] == 6'b001000) begin
				// $display("\n Keyword: JR, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);	
			// // SUBU
			// end else if(instruction_wire_out[5:0] == 6'b100011) begin
				// $display("\n Keyword: SUBU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// // ADDU
			// end else if(instruction_wire_out[5:0] == 6'b100001) begin
				// $display("\n Keyword: ADDU, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// // NOP
			// end else if(instruction_wire_out[25:0] == 26'b0) begin
				// $display("\n Keyword: NOP, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
			// end
			// end
		// default: 
			// $display("\n Keyword: Unknown, PC = %d, nPC = %d", pc_wire_out, npc_wire_out);
		// endcase
		// $display("\n\n --- ID STAGE ---",
        // "\n ID_conditional_unconditional = %b", control_signals_wire[21],
        // "\n ID_r31 = %b", control_signals_wire[20],
        // "\n ID_unconditional_jump = %b", control_signals_wire[19],
        // "\n ID_destination = %b", control_signals_wire[18],
				// "\n ID_SourceOperand_3bits = %b", control_signals_wire[17:15],
				// "\n ID_ALU_OP = %b", control_signals_wire[14:11],
				// "\n ID_Load_Instr = %b", control_signals_wire[10],
				// "\n ID_RF_Enable = %b", control_signals_wire[9],
				// "\n ID_B_Instr = %b", control_signals_wire[8],
				// "\n ID_TA_Instr = %b", control_signals_wire[7],
				// "\n ID_MEM_Size = %b", control_signals_wire[6:5],
				// "\n ID_MEM_RW = %b", control_signals_wire[4],
				// "\n ID_MEM_SE = %b", control_signals_wire[3],
				// "\n ID_Enable_HI = %b", control_signals_wire[2],
				// "\n ID_Enable_LO = %b", control_signals_wire[1],
				// "\n ID_MEM_Enable = %b", control_signals_wire[0],
				// "\n\n --- EX STAGE ---",
				// "\n EX_SourceOperand_3bits = %b", ex_wire[17:15],
				// "\n EX_ALU_OP = %b", ex_wire[14:11],
				// "\n EX_Load_Instr = %b", ex_wire[10],
				// "\n EX_RF_Enable = %b", ex_wire[9],
				// "\n EX_B_Instr = %b", ex_wire[8],
				// "\n EX_MEM_Size = %b", ex_wire[6:5],
				// "\n EX_MEM_RW = %b", ex_wire[4],
				// "\n EX_MEM_SE = %b", ex_wire[3],
				// "\n EX_Enable_HI = %b", ex_wire[2],
				// "\n EX_Enable_LO = %b", ex_wire[1],
				// "\n EX_MEM_Enable = %b", ex_wire[0],
				// "\n\n --- MEM STAGE ---",
				// "\n MEM_Load_Instr = %b", mem_wire[10],
				// "\n MEM_RF_Enable = %b", mem_wire[9],
				// "\n MEM_MEM_Size = %b", mem_wire[6:5],
				// "\n MEM_MEM_RW = %b", mem_wire[4],
				// "\n MEM_MEM_SE = %b", mem_wire[3],
				// "\n MEM_Enable_HI = %b", mem_wire[2],
				// "\n MEM_Enable_LO = %b", mem_wire[1],
				// "\n MEM_MEM_Enable = %b", mem_wire[0],
				// "\n\n --- WB STAGE ---",
				// "\n WB_RF_Enable = %b", wb_wire[9],
				// "\n WB_Enable_HI = %b", wb_wire[2],
				// "\n WB_Enable_LO = %b", wb_wire[1]
		// );
// end


endmodule