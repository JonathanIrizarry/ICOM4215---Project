
module PPU_Control_Unit (
    input   [31:0] instruction,
    output reg [21:0] control_signals //arreglar cantidad de bits
);
    




    reg conditional_inconditional; //bit 21
    reg r31; //bit 20
    reg unconditional_Jump; //bit 19
    reg destination; //bit 18
    reg [2:0] ID_SourceOperand_3bits; //bit 15-17
    reg [3:0] ID_ALU_OP;//bit11-14
    reg ID_Load_Instr;//bit10 
    reg ID_RF_Enable;//bit9
    reg ID_B_Instr; //bit8
    reg ID_TA_Instr;//bit7
    reg [1:0] ID_MEM_Size;//bit5-6
    reg ID_MEM_RW;//bit4
    reg ID_MEM_SE;//bit3
    reg ID_Enable_HI;//bit2
    reg ID_Enable_LO;//bit1
	reg ID_MEM_Enable;//bit0
 


    
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
    parameter BGEZ_OP = 6'b000001;
    parameter B_OP = 6'b000100;



    always @* begin
     control_signals = 22'b0;
     
    if (instruction[31:26] == ADDIU_Op) begin
        ID_SourceOperand_3bits = 3'b100;
        ID_ALU_OP = 4'b0000;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0; // creo que es uno 
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if ((instruction[31:26] == R_TYPE) && (instruction[5:0] == SUBU_Funct)) begin
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;  //creo que es uno 
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if (instruction[31:26] == LBU_Op) begin
        // Handle LBU_Op case
        ID_SourceOperand_3bits = 3'b100;
        ID_ALU_OP = 4'b0000;
        ID_Load_Instr = 1'b1;
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b1;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if (instruction[31:26] == BGTZ_OP) begin //anadir condicional/inco // Handle BGTZ_OP case
        
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b1010;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b0;
        ID_B_Instr = 1'b1;
        ID_TA_Instr = 1'b1;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if (instruction[31:26] == JAL_OP) begin// Handle JAL_OP case
        
        ID_SourceOperand_3bits = 3'b011;
        ID_ALU_OP = 4'b1100;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b1; //bit 21
        r31 = 1'b1; // bit 20
        unconditional_Jump = 1'b1; //bit 19
        destination = 1'b1; //bit 18
    end else if (instruction[31:26] == LUI_OP) begin// Handle LUI_OP case
        
        ID_SourceOperand_3bits = 3'b101;
        ID_ALU_OP = 4'b1011; //puede ser 1100
        ID_Load_Instr = 1'b0;  //no se
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if ((instruction[31:26] == R_TYPE) && (instruction[5:0] == JR_Funct)) begin
         ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0000;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b0;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b1; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b1; //bit 19
        destination = 1'b0; //bit 18

        
    end else if (instruction[31:26] == SB_OP) begin
        // Handle SB_OP case
        ID_SourceOperand_3bits = 3'b100;
        ID_ALU_OP = 4'b0000;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b0;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b1;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18

    end else if(instruction[31:26] == BGEZ_OP)begin
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b1001; //checquea si rs que es puerto A es mayor que 0
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b0;
        ID_B_Instr = 1'b1; //creo
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b0; // 0 cuando es conditional 1 cuando es unconditional
        r31 = 1'b0; 
        unconditional_Jump = 1'b0; 
        destination = 1'b0; 
    end else if(instruction[31:26] == B_OP)begin
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0000;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b0;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b0;
        ID_MEM_SE = 1'b0;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b0;
        conditional_inconditional = 1'b0; 
        r31 = 1'b0; 
        unconditional_Jump = 1'b0; 
        destination = 1'b0;
    end else begin
        // Provide default values or handle other opcodes
    end


    if(instruction == 32'b0  | instruction == 32'bx)begin
        control_signals <= 22'b0;
	
    end else begin
		control_signals <= { conditional_inconditional, r31, unconditional_Jump, destination ,ID_SourceOperand_3bits, ID_ALU_OP, ID_Load_Instr, ID_RF_Enable, ID_B_Instr, ID_TA_Instr, ID_MEM_Size, ID_MEM_RW, ID_MEM_SE, ID_Enable_HI, ID_Enable_LO, ID_MEM_Enable};
    end

end


endmodule