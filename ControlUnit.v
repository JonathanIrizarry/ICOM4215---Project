module PPU_Control_Unit (
    input  [31:0] instruction,
    output reg [14:0] control_output
);

	reg S = 1'b1;
	wire ID_Shift_Imm;
    wire [2:0] ID_ALU_OP;
    wire ID_Load_Instr;
    wire ID_RF_Enable;
    wire ID_B_Instr;
    wire ID_TA_Instr;
    wire [1:0] ID_MEM_Size;
    wire ID_MEM_RW;
    wire ID_MEM_SE;
    wire ID_Enable_HI;
    wire ID_Enable_LO;
	wire ID_MEM_Enable;

    // Opcode values
    parameter R_TYPE = 6'b000000;
    parameter ADDIU_Op = 6'b001001;
    parameter SUBU_Funct = 6'b100011;
    parameter LBU_Op = 6'b100100;
    parameter SUB = 6'b100010;
    parameter SB_OP = 6'b101000;
    parameter BGTZ_OP = 6'b000111; 
    parameter JAL_OP = 6'b000011;
    parameter JR_Funct = 6'b001000;
    parameter LUI_OP = 6'b001111;

   
    
	
    // Control signals
    assign ID_Shift_Imm  = (instruction[31:26] == ADDIU_Op) ? 1'b1 : 1'b0;
    assign ID_ALU_OP     = (instruction[31:26] == ADDIU_Op) ? 3'b001
                       : ((instruction[31:26] == R_TYPE) && (instruction[5:0] == SUBU_Funct)) ? 3'b010
                       : 3'b000;
    assign ID_Load_Instr = (instruction[31:26] == LBU_Op) ? 1'b1 : 1'b0;
    assign ID_RF_Enable  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0;
    assign ID_B_Instr    = (instruction[31:26] == BGTZ_OP) ? 1'b1 : 1'b0;
    assign ID_TA_Instr   = (instruction[31:26] == JAL_OP) ? 1'b1 : 1'b0;
    assign ID_MEM_Size   = (instruction[31:26] == ADDIU_Op) ? 2'b01 // Assuming word-sized memory access for ADDIU
                       : 2'b00; // Default to 00 for other instructions
    assign ID_MEM_RW     = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0; // Assuming store instruction for SB_OP
    assign ID_MEM_SE     = (instruction[31:26] == LBU_Op) ? 1'b1 : 1'b0; // Assuming sign-extension for LBU_Op
    assign ID_Enable_HI  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0;
    assign ID_Enable_LO  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0;
	assign ID_MEM_Enable  = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0;

     // Concatenate control signals based on the mux input
    always @ (instruction) begin
		 control_output = (S) ? {ID_Shift_Imm, ID_ALU_OP, ID_Load_Instr, ID_RF_Enable, ID_B_Instr, ID_TA_Instr, ID_MEM_Size, ID_MEM_RW, ID_MEM_SE, ID_Enable_HI, ID_Enable_LO, ID_MEM_Enable} : 15'b0;
    end


endmodule