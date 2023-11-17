module instr_mem (
    output reg [31:0] DataOut,
    input [8:0] Address
);

    reg [7:0] Mem[0:511]; //512 localizaciones de 8 bits
    
    always @ (Address)
        DataOut <= {Mem[Address], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};
    
endmodule

module SimplePipeline(
    input wire clk,
    input wire reset,
    input wire [31:0] instruction_in,
    output wire [31:0] result_out
);

    reg [31:0] pc_reg;
    reg [31:0] npc_reg;
    reg [31:0] instruction_reg;
    reg [31:0] alu_result;
    reg [31:0] mem_result;
    reg [31:0] result_reg;
    reg [8:0] address;

    // Load enable for PC and nPC
    reg le_pc, le_npc, le_alu, le_mem, le_wb;

    // Outputs from ID stage
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] immediate;
    wire [5:0] funct;

    // Bus for control signals
    wire [12:0] control_bus;



    // Initialization of Instruction Memory
    instr_mem imem (
        .DataOut(instruction_reg),
        .Address(address)
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

      // Etapa IF (Fetch)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= 32'h0;
            npc_reg <= 32'h4;
            instruction_reg <= 32'h0;
            le_pc <= 1'b0;
            le_npc <= 1'b0;
        end else begin
            if (le_pc) pc_reg <= npc_reg;
            address <= pc_reg;
            if (le_npc) npc_reg <= npc_reg + 4;
            instruction_reg <= instruction_in;
        end
    end

    // Etapa ID (Decodificación de Instrucciones)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize control signals
            // Add your initialization logic here if needed
        end else begin
            // Pass the instruction through the control unit
            PPU_Control_Unit control_unit(
               .instruction(instruction_reg),
                .ID_Shift_Imm(ID_Shift_Imm),
                .ID_ALU_OP(ID_ALU_OP),
                .ID_Load_Instr(ID_Load_Instr),
                .ID_RF_Enable(ID_RF_Enable),
                .ID_B_Instr(ID_B_Instr),
                .ID_TA_Instr(ID_TA_Instr),
                .ID_MEM_Size(ID_MEM_Size),
                .ID_MEM_RW(ID_MEM_RW),
                .ID_MEM_SE(ID_MEM_SE),
                .ID_Enable_HI(ID_Enable_HI),
                .ID_Enable_LO(ID_Enable_LO)
            );
       
          
        end
    end

    // Etapa EX (Ejecución)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset
        end else begin
            // Lógica de la etapa EX, como operaciones aritméticas y lógicas
            if (le_alu) begin
                // Perform ALU operation
            end
        end
    end

    // Etapa MEM (Acceso a memoria)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset
        end else begin
            // Lógica de la etapa MEM, como acceso a memoria (load o store)
            if (le_mem) begin
                // Perform memory operation
            end
        end
    end

    // Etapa WB (Write-Back)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset
        end else begin
            result_reg <= mem_result; // En una implementación real, puedes seleccionar entre alu_result y mem_result según la instrucción
        end
    end

    // Assign the result
    assign result_out = result_reg;

endmodule



module PPU_Control_Unit (
    input wire [31:0] instruction,
    output wire ID_Shift_Imm,
    output wire [2:0] ID_ALU_OP,
    output wire ID_Load_Instr,
    output wire ID_RF_Enable,
    output wire ID_B_Instr,
    output wire ID_TA_Instr,
    output wire [1:0] ID_MEM_Size,
    output wire ID_MEM_RW,
    output wire ID_MEM_SE,
    output wire ID_Enable_HI,
    output wire ID_Enable_LO
);

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


     // Concatenate control signals based on the mux input
    always @* begin
        control_output = (S) ? {ID_Shift_Imm, ID_ALU_OP, ID_Load_Instr, ID_RF_Enable, ID_B_Instr, ID_TA_Instr, ID_MEM_Size, ID_MEM_RW, ID_MEM_SE, ID_Enable_HI, ID_Enable_LO} : 12'b0;
    end

endmodule

``
