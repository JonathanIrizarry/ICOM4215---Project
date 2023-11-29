
module PPU_Control_Unit (
    input   [31:0] instruction,
    output reg [21:0] control_signals //arreglar cantidad de bits
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

    reg [2:0] ID_SourceOperand_3bits;
    reg [3:0] ID_ALU_OP;
    reg ID_Load_Instr;
    reg ID_RF_Enable;
    reg ID_B_Instr;
    reg ID_TA_Instr;
    reg [1:0] ID_MEM_Size;
    reg ID_MEM_RW;
    reg ID_MEM_SE;
    reg ID_Enable_HI;
    reg ID_Enable_LO;
	reg ID_MEM_Enable;

    reg conditional_inconditional;
    reg r31;
    reg unconditional_Jump;
    reg destination;


    
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

//inicializar control signals
    
    
	
    // // Control signals                  //bit 15-17
    // assign ID_SourceOperand_3bits  = (instruction[31:26] == ADDIU_Op) ? 3'b100 : ((instruction[31:26] == R_TYPE) && (instruction[5:0] == SUBU_Funct)) ? 3'b000 : 3'b000; // source operand 2 handler sign control 3 bits definit cuan senal sale pa cada instruccion
	
    // assign ID_ALU_OP = (instruction[31:26] == ADDIU_Op) ? 4'b0000 : ((instruction[31:26] == R_TYPE) && (instruction[5:0] == SUBU_Funct)) ? 4'b0001 : 4'b0000; //bit11-14
   
    // assign ID_Load_Instr = (instruction[31:26] == LBU_Op) ? 1'b1 : 1'b0; //bit10 
    
    // assign ID_RF_Enable  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0; //bit9   //rf es 1 para addi
   
    // assign ID_B_Instr    = (instruction[31:26] == BGTZ_OP) ? 1'b1 : 1'b0; //bit8
    
    // assign ID_TA_Instr   = (instruction[31:26] == JAL_OP) ? 1'b1 : 1'b0; //bit7
   
    // assign ID_MEM_Size   = (instruction[31:26] == ADDIU_Op) ? 2'b01  : 2'b00; //bit5-6
   
    // assign ID_MEM_RW     = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0; //bit4
   
    // assign ID_MEM_SE     = (instruction[31:26] == LBU_Op) ? 1'b1 : 1'b0; //bit3
   
    // assign ID_Enable_HI  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0; //bit2 // arreglar
   
    // assign ID_Enable_LO  = (instruction[31:26] == R_TYPE) ? 1'b1 : 1'b0; //bit1  //arreglar instrucciones que cargan HI oLO
	
    // assign ID_MEM_Enable  = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0; //bit0



    always @* begin
     control_signals = 22'b0;
     
    if (instruction[31:26] == ADDIU_Op) begin
        ID_SourceOperand_3bits = 3'b100;
        ID_ALU_OP = 4'b0000;
        ID_Load_Instr = 1'b1;
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b01;
        ID_MEM_RW = 1'b0;
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
        ID_MEM_RW = 1'b0;
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
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
        ID_Load_Instr = 1'b1;
        ID_RF_Enable = 1'b1;
        ID_B_Instr = 1'b0;
        ID_TA_Instr = 1'b0;
        ID_MEM_Size = 2'b00;
        ID_MEM_RW = 1'b1;
        ID_MEM_SE = 1'b1;
        ID_Enable_HI = 1'b0;
        ID_Enable_LO = 1'b0;
        ID_MEM_Enable = 1'b1;
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if (instruction[31:26] == R_TYPE) begin // borrar
        // Handle other R_TYPE cases if needed
         ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
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
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if (instruction[31:26] == BGTZ_OP) begin //anadir condicional/inco // Handle BGTZ_OP case
        
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b1010;
        ID_Load_Instr = 1'b0;
        ID_RF_Enable = 1'b1;
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
        
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
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
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if (instruction[31:26] == LUI_OP) begin// Handle LUI_OP case
        
             ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
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
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else if ((instruction[31:26] == R_TYPE) && (instruction[5:0] == JR_Funct)) begin
         ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
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
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18

        
    end else if (instruction[31:26] == SB_OP) begin
        // Handle SB_OP case
        ID_SourceOperand_3bits = 3'b000;
        ID_ALU_OP = 4'b0001;
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
        conditional_inconditional = 1'b0; //bit 21
        r31 = 1'b0; // bit 20
        unconditional_Jump = 1'b0; //bit 19
        destination = 1'b0; //bit 18
    end else begin
        // Provide default values or handle other opcodes
    end



   
//always @ (*) begin
    // control_signals <= 22'b0;

    if(instruction == 32'b0  | instruction == 32'bx)begin
        control_signals <= 22'b0;
		//$display();
    end else begin
		control_signals <= { conditional_inconditional, r31, unconditional_Jump, destination ,ID_SourceOperand_3bits, ID_ALU_OP, ID_Load_Instr, ID_RF_Enable, ID_B_Instr, ID_TA_Instr, ID_MEM_Size, ID_MEM_RW, ID_MEM_SE, ID_Enable_HI, ID_Enable_LO, ID_MEM_Enable};
    end





end


endmodule