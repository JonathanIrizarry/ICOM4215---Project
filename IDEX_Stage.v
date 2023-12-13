module IDEX_Stage (
    input clk,
    input reset,
    input [21:0] control_signals,
    input [31:0] targetAddress_in,
    input ID_hi,
    input ID_lo,
    input [31:0] ID_muxA,
    input [31:0] ID_muxB,
    input [31:0] ID_PB,
    input [15:0] ID_imm16,
    input [31:26] ID_opcode,
    input [8:0] ID_PC,
    input [15:11] ID_rd,
    input [20:16] ID_rt,
    input [4:0] ID_r31, //check cuantos bits
    input [8:0] ID_PC8, //changed from 31:0 to 8:0
    output reg [21:0] control_signals_out,
	output reg [3:0] alu_op_reg,
    output reg [5:0] conditionHandler_opcode,
    output reg EX_branch_instr,
    output reg load_instr_reg,
    output reg rf_enable_reg,
    output reg [2:0] SourceOperand_3bits,
    output reg SourceOperand_Hi,
    output reg SourceOperand_Lo,
    output reg [31:0] SourceOperand_PB,
    output reg [31:0] alu_A,
    output reg [8:0] EX_PC,
    output reg [15:0] EX_imm16,
    output reg [15:11] EX_rd,
    output reg [8:0] EX_PC8, //changed from 31:0 to 8:0
    output reg [20:16] EX_rt,
    //output reg [31:26] opcode,
    output reg [4:0] EX_R31,
    output reg [31:0] targetAddress_out
);
    // Execute stage logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
        // Inicializar registros en caso de reset'
			alu_op_reg <= 4'b0000;
			EX_branch_instr <= 1'b0;
			load_instr_reg <= 1'b0;
			rf_enable_reg <= 1'b0;
			SourceOperand_3bits <= 3'b000;
			control_signals_out <= 22'b0;
            conditionHandler_opcode <= 6'b0;
			SourceOperand_Hi <= 1'b0;
			SourceOperand_Lo <= 1'b0;
			SourceOperand_PB <= 32'b0;
			alu_A <= 32'b0;
			EX_PC <= 9'b0;
			EX_imm16 <= 16'b0;
			EX_rd <= 5'b0;
			EX_PC8 <= 9'b0;
			EX_rt <= 5'b0;
			EX_R31 <= 5'b0;
            targetAddress_out <= 32'b0;
			
        end else begin
            // Lógica de la etapa EX, como operaciones aritméticas y lógicas
			alu_op_reg <= control_signals[14:11];
			EX_branch_instr <= control_signals[8];
			load_instr_reg <= control_signals[10];
			rf_enable_reg <= control_signals[9];
			SourceOperand_3bits <= control_signals[17:15];
            control_signals_out <= control_signals;
            conditionHandler_opcode <= ID_opcode;
            SourceOperand_Hi <= control_signals[2];
            SourceOperand_Lo <= control_signals[1];
            SourceOperand_PB <= ID_PB;
            alu_A <= ID_muxA;
            EX_PC <= ID_PC;
            EX_imm16 <= ID_imm16;
            EX_rd <= ID_rd;
            EX_PC8 <= ID_PC8;
            EX_rt <= ID_rt;
            EX_R31 <= ID_r31;
            targetAddress_out <= targetAddress_in;


        end

    end

endmodule
