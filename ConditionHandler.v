module Condition_Handler(
    input B_instr;
    input [31:26] opcode;
    input flag;  
    input rt; //bits 20:16 de instruction
    output reg  handler_Out;
);


always @* begin

    handler_Out <= B_instr;
end

endmodule




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LogicBox(
    input Handler_B_instr;
    input unconditional_jump_signal;
    output reg logicbox_out;
);

    always @* begin
        if(B_instr == 1'b1 || unconditional_jump_signal == 1'b1)begin
                logicbox_out <= 1'b1;
        end else begin
                logicbox_out <= 1'b0;
        end


    end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



module LogicBox_mux(
    input logicbox_out; // 1 bit
    input [31:0] IF_mux;  
    input [31:0] nPC_input;  
    output reg [31:0] Logic_mux_output;  
);
    always @* begin
        if(logicbox_out == 1'b1) begin
            Logic_mux_output <= IF_mux; //TA or rs


        end else begin
             Logic_mux_output <= nPC_input; // npc

        end
       

    end 

endmodule


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module IF_Mux(
    input [31:0] EX_TA;
    input [31:0] ID_TA;   //concatenau 30 bits y multiplicau 32?? 
    input [5:0] rs; //chequear que manda
    input TA_instruction; 
    output reg [31:0]mux_out;  
);

always @* begin  
    if(TA_instruction == 1'b1)begin
        mux_out <= ID_TA;   // cheuqear differencia entre id y EX TA
    end else begin
        mux_out = {26'b0 , rs};
    end
end


endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////