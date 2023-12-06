module HazardForwardingUnit(
	input reg [4:0] rs,
	input reg [4:0] rt,
	input EX_load_instr,
	input EX_RF_Enable,
	input MEM_RF_Enable,
	input WB_RF_Enable,
	input reg [4:0] rd_ex,
	input reg [4:0] rd_mem,
	input reg [4:0] rd_wb,
	output [1:0] mux1_select,
	output [1:0] mux2_select,
	output [1:0] control_select
	output IFID_LE,
	output PC_LE
)

always @ (*) begin
	//Forwarding RA
	if(EX_RF_Enable && (rs == rd_ex))
		mux1_select <= 2'b01;
		else if(MEM_RF_Enable && (rs == rd_mem))
			mux1_select <= 2'b01;
			else if(WB_RF_Enable && (rs == rd_wb))
				mux1_select <= 2'b11;
				else 
					mux1_select <= 2'b00;
					
	//Forwarding RB
	if(EX_RF_Enable && (rt == rd_ex))
		mux2_select <= 2'b01;
		else if(MEM_RF_Enable && (rt == rd_mem))
			mux2_select <= 2'b01;
			else if(WB_RF_Enable && (rt == rd_wb))
				mux2_select <= 2'b11;
				else 
					mux2_select <= 2'b00;
					
	//Load Hazard
	if(EX_load_instr && ((rs == rd_ex) || (rt == rd_ex))) begin
		PC_LE <= 1'b0;
		IFID_LE <= 1'b0;
		control_select <= 1'b0;
	end 
	else begin
		PC_LE <= 1'b1;
		IFID_LE <= 1'b1;
		control_select <= 1'b0;
	end
end
