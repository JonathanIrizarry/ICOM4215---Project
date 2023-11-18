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
	reg [0] load_instr_reg;
	reg [0] rf_enable_reg;
	reg [0] branch_reg;
	reg [0] ta_instr_reg;
	reg [0] mem_enable_reg;
	reg [0] mem_se_reg;
	reg [0] mem_rw_reg;
	reg [1:0] mem_size_reg;
	reg [0] hi_enable_reg;
	reg [0] lo_enable_reg;

    // Load enable for PC and nPC
    reg le_pc, le_npc, le_alu, le_mem, le_wb;

    // Outputs from ID stage
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] immediate;
    wire [5:0] funct;


    // Initialization of Instruction Memory
    instr_mem imem (
        .DataOut(instruction_reg),
        .Address(address)
    );
	

      // Etapa IF (Fetch)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_reg <= 32'h0;
            npc_reg <= 32'b00000000000000000000000000000100;
            instruction_reg <= 32'h0;
            le_pc <= 1'b0;
            le_npc <= 1'b0;
        end else begin
            if (le_pc) pc_reg <= npc_reg;
            address <= pc_reg;
            instruction_reg <= instruction_in;
            if (le_npc) npc_reg <= npc_reg + 4;
            
        end
    end

    // Etapa ID (Decodificación de Instrucciones)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize control signals
            // Add your initialization logic here if needed
			ta_instr_reg = 1'b0;
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
                .ID_Enable_LO(ID_Enable_LO),
				.ID_MEM_Enable(ID_MEM_Enable)
            );
			
			ta_instr_reg = control_output[7];
          
        end
    end

    // Etapa EX (Ejecución)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset'
			alu_op_reg = 3'b000;
			branch_reg = 1'b0;
			load_instr_reg = 1'b0;
			rf_enable_reg = 1'b0;
        end else begin
            // Lógica de la etapa EX, como operaciones aritméticas y lógicas
			alu_op_reg = control_output[3:1];
			branch_reg = control_output[6];
			load_instr_reg = control_output[4];
			rf_enable_reg = control_output[5];
            if (le_alu) begin
                // Perform ALU operation
            end
        end
    end

    // Etapa MEM (Acceso a memoria)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset
			mem_size_reg = 2'b00;
			mem_se_reg = 1'b0;
			mem_rw_reg = 1'b0; 
			mem_enable_reg = 1'b0;
			load_instr_reg = 1'b0;		
			rf_enable_reg = 1'b0;			
        end else begin
            // Lógica de la etapa MEM, como acceso a memoria (load o store)
			mem_size_reg = control_output[9:8];
			mem_se_reg = control_output[11];
			mem_rw_reg = control_output[10];
			mem_enable_reg = control_output[14];
			load_instr_reg = control_output[4];
			rf_enable_reg = control_output[5];
			//mem_mux_enable = ??
            if (le_mem) begin
                // Perform memory operation
            end
        end
    end

    // Etapa WB (Write-Back)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset
			rf_enable_reg = 1'b0;
			hi_enable_reg = 1'b0;
			lo_enable_reg = 1'b0;
        end else begin
            result_reg <= mem_result; 
			rf_enable_reg = control_output[5];
			hi_enable_reg = control_output[12];
			lo_enable_reg = control_output[13];
			// En una implementación real, puedes seleccionar entre alu_result y mem_result según la instrucción
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
    output wire ID_Enable_LO,
	output wire ID_MEM_Enable
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
	assign ID_MEM_Enable  = (instruction[31:26] == SB_OP) ? 1'b1 : 1'b0;

     // Concatenate control signals based on the mux input
    always @* begin
        control_output = (S) ? {ID_Shift_Imm, ID_ALU_OP, ID_Load_Instr, ID_RF_Enable, ID_B_Instr, ID_TA_Instr, ID_MEM_Size, ID_MEM_RW, ID_MEM_SE, ID_Enable_HI, ID_Enable_LO, ID_MEM_Enable} : 15'b0;
    end

endmodule



`timescale 1ns/1ps

module SimplePipeline_TB;

  // Define parameters
  reg clk, reset, S, le_npc,le_pc;
  reg [31:0] test_instruction;
  wire [31:0] test_result;
  wire [31:0] pc_reg;
  wire [31:0] npc_reg;
  
  // Instantiate your SimplePipeline module
  SimplePipeline_DUT dut (
    .clk(clk),
    .reset(reset),
    .instruction_reg(test_instruction),
    .result_out(test_result),
    .pc_reg(pc_reg),
    .npc_reg(npc_reg)
  );

  // Clock generation
  always begin
    #2 clk = ~clk; // Invert the clock every 2 time unit
  end

  // Initial block for setup
  initial begin
    // Initialize signals
    clk = 1'b0;
    reset = 1'b1;
    S = 1'b0;
    le_npc = 1;
    le_pc = 1;
    test_instruction = 32'b00100100000001010000000000000000; // Example: ADDIU instruction
    
    // Apply reset
    #2 reset = 1'b0;

    // Apply S signal
    #40 S = 1'b1;

    // Simulate until time 48
    #48 $finish;
  end

  // Display information at each clock cycle
  always @(posedge clk) begin
    // Print keyword, PC, nPC, and control signals
    $display("%s PC=%0d nPC=%0d Control Signals=%b", dut.PPU_Control_Unit.ID_Load_Instr ? "ADDIU" : "Unknown", dut.pc_reg, dut.npc_reg, dut.control_output);

    // Print control signals of EX, MEM, and WB stages
    $display("EX: %b MEM: %b WB: %b", dut.alu_op_reg, dut.mem_enable_reg, dut.rf_enable_reg);
  end

endmodule


