`include "ControlUnit.v"
`include "InstructionMemory.v"
`include "EX_Stage.v"
`include "ID_Stage.v"
`include "IF_Stage.v"
`include "MEM_Stage.v"
`include "MUX.v"
`include "nPC_Reg.v"
`include "PC_Reg.v"
`include "WB_Stage.v"
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
    .Address(pc_wire_out[8:0])
);



	//Preload Instruction Memory
	initial begin
		fi = $fopen("input.txt","r");
		address = 9'b000000000;
		while (!$feof(fi)) begin
			code = $fscanf(fi, "%b", data);
			imem.Mem[address] = data;
			address = address + 1;
	end
	$fclose(fi);
	end

 // always @(posedge clk or posedge reset) begin
    // if (reset) begin
        // // Reset: Set initial address value
        // address <= 32'b00000000000000000000000000000000;
    // end else begin
        // // Assign the value from pc_out to address
        // address <= pc_wire_out;
    // end
// end



PPU_Control_Unit control_unit(
    .instruction(instruction_wire_out),
    .control_signals(control_signals_wire)
  );    


mux mux_instance(
    .input_0(control_signals_wire),
    .S(S), // por ahora
    .mux_control_signals(mux_out_wire)
);


IF_Stage if_instance(
    .clk(clk),
    .reset(reset),
    .instruction_in(DataOut),
    .instruction_out(instruction_wire_out)
);

ID_Stage id_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mux_out_wire),
    .control_signals_out(mux_out_wire)
);

EX_Stage ex_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mux_out_wire),
    .control_signals_out(mux_out_wire)
);
MEM_Stage mem_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mux_out_wire),
    .control_signals_out(mux_out_wire)
);
WB_Stage wb_instance(
    .clk(clk),
    .reset(reset),
    .control_signals(mux_out_wire),
    .control_signals_out(mux_out_wire)
);


always @ (posedge clk) begin
	$display("npc = %d, pc = %d, addr = %b, clk = %b, reset = %b, time = %d", npc_wire_out, pc_wire_out, DataOut, clk, reset, $time);
end

endmodule