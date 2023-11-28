
module PPU_Control_Unit (
	input clk,
    input   [31:0] instruction,
    output reg [16:0] control_signals //arreglar cantidad de bits
);

	// reg [2:0] ID_Shift_Imm;
    // reg [2:0] ID_ALU_OP;
    // reg ID_Load_Instr;
    // reg ID_RF_Enable;
    // reg ID_B_Instr;
    // reg ID_TA_Instr;
    // reg [1:0] ID_MEM_Size;
    // reg ID_MEM_RW;
    // reg ID_MEM_SE;
    // reg ID_Enable_HI;
    // reg ID_Enable_LO;
	// reg ID_MEM_Enable;

    wire [2:0] ID_SourceOperand_3bits;
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
    //parameter SUB = 6'b100010;
    parameter SB_OP = 6'b101000;
    parameter BGTZ_OP = 6'b000111; 
    parameter JAL_OP = 6'b000011;
    parameter JR_Funct = 6'b001000;
    parameter LUI_OP = 6'b001111;

   
    
	
    // Control signals                  //bit 14-16
    assign ID_SourceOperand_3bits  = (instruction[31:26] == ADDIU_Op) ? 3'b001 : 3'b000; // source operand 2 handler sign control 3 bits definit cuan senal sale pa cada instruccion
   assign ID_ALU_OP = (instruction[31:26] == ADDIU_Op) ? 3'b000 : ((instruction[31:26] == R_TYPE) && (instruction[5:0] == SUBU_Funct)) ? 3'b001 : 3'b000; //bit11-13
    assign ID_Load_Instr = (instruction[31:26] == LBU_Op) ? 1'b1 : 1'b0; //bit10 
    assign ID_RF_Enable  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0; //bit9 
    assign ID_B_Instr    = (instruction[31:26] == BGTZ_OP) ? 1'b1 : 1'b0; //bit8
    assign ID_TA_Instr   = (instruction[31:26] == JAL_OP) ? 1'b1 : 1'b0; //bit7
    assign ID_MEM_Size   = (instruction[31:26] == ADDIU_Op) ? 2'b01  : 2'b00; //bit5-6
    assign ID_MEM_RW     = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0; //bit4
    assign ID_MEM_SE     = (instruction[31:26] == LBU_Op) ? 1'b1 : 1'b0; //bit3
    assign ID_Enable_HI  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0; //bit2
    assign ID_Enable_LO  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0; //bit1
	assign ID_MEM_Enable  = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0; //bit0

   
always @ (instruction) begin
    if(instruction == 32'b0 )begin
        control_signals <= 32'b0;
    end else begin
 control_signals <= {ID_SourceOperand_3bits, ID_ALU_OP, ID_Load_Instr, ID_RF_Enable, ID_B_Instr, ID_TA_Instr, ID_MEM_Size, ID_MEM_RW, ID_MEM_SE, ID_Enable_HI, ID_Enable_LO, ID_MEM_Enable};
    end
end




 
  


endmodule