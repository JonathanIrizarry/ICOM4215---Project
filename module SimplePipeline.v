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

// Load enable for PC and nPC
reg le_pc, le_npc;

// Outputs from ID stage
wire [5:0] opcode;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [15:0] immediate;
wire [5:0] funct;

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
        if (le_npc) npc_reg <= npc_reg + 4;
        instruction_reg <= instruction_in;
    end
end

// Etapa ID (Decodificación de Instrucciones)
ID_Stage id_stage (
    .clk(clk),
    .reset(reset),
    .instruction(instruction_reg),
    .opcode(opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .immediate(immediate),
    .funct(funct)
);

// Etapa EX (Ejecución)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Inicializar registros en caso de reset
    end else begin
        // Lógica de la etapa EX, como operaciones aritméticas y lógicas
    end
end

// Etapa MEM (Acceso a memoria)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Inicializar registros en caso de reset
    end else begin
        // Lógica de la etapa MEM, como acceso a memoria (load o store)
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

// Unidad de control
PPU_Control_Unit control_unit(
    .opcode(opcode),
    .ppu_instr(funct),  // O utiliza otro campo dependiendo de tu diseño
    .MemRead(),  // Agrega las señales específicas para MEM, EX, WB, etc.
    .MemWrite(),
    .MemToReg(),
    .RegWrite(),
    .ALUSrc(),
    .ALUOp(),
    .RegDst(),
    .Jump(),
    .Branch()
);

assign result_out = result_reg;

endmodule

module ID_Stage(
    input wire clk,
    input wire reset,
    input wire [31:0] instruction,
    output wire [5:0] opcode,
    output wire [4:0] rs,
    output wire [4:0] rt,
    output wire [4:0] rd,
    output wire [15:0] immediate,
    output wire [5:0] funct
);

// Registros de salida
reg [5:0] opcode;
reg [4:0] rs;
reg [4:0] rt;
reg [4:0] rd;
reg [15:0] immediate;
reg [5:0] funct;

// Etapa ID (Decodificación de Instrucciones)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Inicializar registros en caso de reset
    end else begin
        // Extraer campos de la instrucción
        opcode <= instruction[31:26];
        rs <= instruction[25:21];
        rt <= instruction[20:16];
        rd <= instruction[15:11];
        immediate <= instruction[15:0];
        funct <= instruction[5:0];
    end
end

endmodule
