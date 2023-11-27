module ID_Stage (
    input clk,
    input reset,
    input [16:0] control_signals,
	output reg ta_instr_reg,
    output reg [16:0] control_signals_out
 
);

   //reg ta_instr_reg;

    always @(posedge clk) begin
        if (reset) begin
          
			ta_instr_reg = 1'b0;
        end else begin
			ta_instr_reg = control_signals[7];
            control_signals_out <= control_signals;
			
			
        end
    end

endmodule

