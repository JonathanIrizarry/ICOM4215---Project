module EXMEM_Stage (
    input clk,
    input reset,
    input [16:0] control_signals,
    output reg [16:0] control_signals_out,
	output reg [1:0] mem_size_reg,
    output reg mem_se_reg,
    output reg mem_rw_reg,
    output reg mem_enable_reg,
    output reg load_instr_reg,
    output reg rf_enable_reg
   
);
    // input [5:0] opcode,
    // input [4:0] rs,
    // input [4:0] rt,
    // input [4:0] rd,
    // input [15:0] immediate,
    // input [5:0] funct,
    // input [2:0] alu_op_reg,
    // input [31:0] result_reg,
    // output reg [31:0] mem_result

    // reg mem_size_reg;
    // reg mem_se_reg;
    // reg mem_rw_reg;
    // reg mem_enable_reg;
    // reg load_instr_reg;
    // reg rf_enable_reg;

   
    // Memory stage logic
    always @(posedge clk) begin
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
			mem_size_reg = control_signals[6:5];
			mem_se_reg = control_signals[3];
			mem_rw_reg = control_signals[4];
			mem_enable_reg = control_signals[0];
			load_instr_reg = control_signals[10];
			rf_enable_reg = control_signals[9];
			control_signals_out <= control_signals;
			
			
            // if (le_mem) begin
            //     // Perform memory operation
            // end
        end

    end

endmodule
