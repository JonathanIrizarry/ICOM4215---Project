module MEMWB_Stage (
    input clk,
    input reset,
    input [21:0] control_signals,
    output reg [21:0] control_signals_out,
    input [4:0] mem_r31_in,
    input [31:0] mux_mem_in,
    output reg [31:0] mux_wb_out,
	output reg rf_enable_reg,
	output reg hi_enable_reg,
    output reg lo_enable_reg,
    output reg [15:11] wb_rd_out,
    output reg [4:0] wb_r31_out

  
);


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Inicializar registros en caso de reset
			rf_enable_reg <= 1'b0;
			hi_enable_reg <= 1'b0;
			lo_enable_reg <= 1'b0;
			control_signals_out <= 22'b0;
        end else begin
            // result_reg <= mem_result; 
			rf_enable_reg <= control_signals[9];
			hi_enable_reg <= control_signals[2];
			lo_enable_reg <= control_signals[1];
			control_signals_out <= control_signals;
			// En una implementación real, puedes seleccionar entre alu_result y mem_result según la instrucción
			mux_wb_out <= mux_mem_in;
            //wb_rd_out <=
            wb_r31_out <= mem_r31_in;
			
			
        end

    end

endmodule
