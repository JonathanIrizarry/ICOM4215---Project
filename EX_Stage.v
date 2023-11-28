module EX_Stage (
    input clk,
    input reset,
    input [16:0] control_signals,
    output reg [16:0] control_signals_out
);

    // input [5:0] opcode,
    // input [4:0] rs,
    // input [4:0] rt,
    // input [4:0] rd,
    // input [15:0] immediate,
    // input [5:0] funct,
     reg [2:0] alu_op_reg;
     reg branch_reg;
     reg load_instr_reg;
     reg rf_enable_reg;
     reg SourceOperand_3bits;
   

    // Execute stage logic
    always @(posedge clk ) begin
        if (reset) begin
        // Inicializar registros en caso de reset'
			alu_op_reg = 3'b000;
			branch_reg = 1'b0;
			load_instr_reg = 1'b0;
			rf_enable_reg = 1'b0;
			SourceOperand_3bits = 3'b000;
        end else begin
            // Lógica de la etapa EX, como operaciones aritméticas y lógicas
			alu_op_reg = control_signals[13:11];
			branch_reg = control_signals[8];
			load_instr_reg = control_signals[10];
			rf_enable_reg = control_signals[9];
			SourceOperand_3bits = control_signals[16:14];
            control_signals_out <= control_signals;
			
			
			
            // if (le_alu) begin
            //     // Perform ALU operation
            // end
        end

    end

endmodule
