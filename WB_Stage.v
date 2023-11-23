module WB_Stage (
    input clk,
    input reset,
    input [16:0] control_signals,
    output [16:0] control_signals_out
  
);
//   input [5:0] opcode,
//     input [4:0] rs,
//     input [4:0] rt,
//     input [4:0] rd,
//     input [15:0] immediate,
//     input [5:0] funct,
//     input [2:0] alu_op_reg,
//     input [31:0] mem_result,
//     output reg [31:0] result_out
  
  reg rf_enable_reg;
  reg hi_enable_reg;
  reg lo_enable_reg;

    always @(posedge clk) begin
        if (reset) begin
            // Inicializar registros en caso de reset
			rf_enable_reg = 1'b0;
			hi_enable_reg = 1'b0;
			lo_enable_reg = 1'b0;
        end else begin
            // result_reg <= mem_result; 
			rf_enable_reg = control_signals[9];
			hi_enable_reg = control_signals[2];
			lo_enable_reg = control_signals[1];
			// En una implementación real, puedes seleccionar entre alu_result y mem_result según la instrucción
			
			
			
        end

    end

endmodule
