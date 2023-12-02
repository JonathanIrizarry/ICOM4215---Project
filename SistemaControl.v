`include "ControlUnit.v"
`include "InstructionMemory.v"
`include "IFID_Stage.v"
`include "MUX.v"
`include "nPC_Reg.v"
`include "PC_Reg.v"
`include "ID_Stage.v"
`include "DataMemory.v"
`include "ALU.v"
`include "Operand2Handler.v"

module SistemaControl (
    input clk,
    input reset
);




wire [31:0] npc_wire_out;
wire [31:0] pc_wire_in;
wire [31:0] pc_wire_out;
wire [31:0] adder_wire_out;
reg [8:0] address;
wire [31:0] DataOut;
wire [21:0] control_signals_wire;
wire [21:0] mux_out_wire;
wire [31:0] instruction_wire_out;

wire [25:0] address_26_out; // bit 25:0 de instruction 
wire [8:0] PC_out; //bit8:0
wire [25:21] rs_out; //bit 25:21
wire [20:16] rt_out; //bit 20:16
wire [15:0] imm16_out; //bit 15:0
wire [31:26] opcode_out; //bit 31:26
wire [15:11] rd_out;






reg [7:0] data;
integer fi, fo, code, i; 
reg [3:0] alu_op_reg;
reg [31:0] mem_result;
reg [31:0] result_reg;
reg load_instr_reg;
reg [2:0] sourceOperand_3bit_reg;
reg rf_enable_reg;
reg branch_reg;
reg ta_instr_reg;
reg mem_enable_reg;
reg mem_se_reg;
reg mem_rw_reg;
reg [1:0] mem_size_reg;
reg hi_enable_reg;
reg lo_enable_reg;



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
    .instruction_out(instruction_wire_out),
   // .ta_instr_reg(),
    .address_26(address_26_out),
    .PC(PC_out),
    .rs(rs_out),
    .rt(rt_out),
    .imm16(imm16_out),
    .opcode(opcode_out),
    .rd(rd_out)
);

// ID_Stage id_instance(
//     .clk(clk),
//     .reset(reset),
//     .control_signals(mux_out_wire),
//     .control_signals_out(mux_out_wire)
// );



endmodule