module EXMEM_Stage (
    input clk,
    input reset,
    input [21:0] control_signals,
    input [31:0] EX_PA,
    input [31:0] EX_ALU,
    input flag,
    input [15:11] EX_rd,
    input [8:0] EX_PC8, //changed from 31:0 to 8:0
    input EX_R31,
    output reg [21:0] control_signals_out,
	output reg [1:0] mem_size_reg,
    output reg mem_se_reg,
    output reg mem_rw_reg,
    output reg mem_enable_reg,
    output reg load_instr_reg,
    output reg rf_enable_reg,
    output reg [31:0] MEM_PA_out,
    output reg [31:0] MEM_ALU_out,
    output reg [15:11] MEM_rd_out,
    output reg [8:0] MEM_PC8_out, //changed from 31:0 to 8:0
    output reg MEM_R31_out
);
  
   
    // Memory stage logic
    always @(posedge clk or posedge reset) begin
     if (reset) begin
            // Inicializar registros en caso de reset
			mem_size_reg <= 2'b00;
			mem_se_reg <= 1'b0;
			mem_rw_reg <= 1'b0; 
			mem_enable_reg <= 1'b0;
			load_instr_reg <= 1'b0;		
			rf_enable_reg <= 1'b0;
			control_signals_out <= 22'b0;
            MEM_PA_out <= 32'b0;
             MEM_ALU_out <= 32'b0;
             MEM_rd_out <= 5'b0;
             MEM_PC8_out <= 32'b0;
             MEM_R31_out <= 32'b0;


			
        end else begin
            // Lógica de la etapa MEM, como acceso a memoria (load o store)
			mem_size_reg <= control_signals[6:5];
			mem_se_reg <= control_signals[3];
			mem_rw_reg <= control_signals[4];
			mem_enable_reg <= control_signals[0];
			load_instr_reg <= control_signals[10];
			rf_enable_reg <= control_signals[9];
			control_signals_out <= control_signals;
			 MEM_PA_out <= EX_PA;
             MEM_ALU_out <= EX_ALU;
             MEM_rd_out <= EX_rd;
             MEM_PC8_out <= EX_PC8;
             MEM_R31_out <= EX_R31;

			
          
        end

    end

endmodule
