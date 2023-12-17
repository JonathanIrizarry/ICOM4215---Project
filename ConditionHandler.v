module Condition_Handler(
    input B_instr,
    input [31:26] opcode,
    input [1:0] flag,   // Z and N los dos juntos?
    input [4:0] rt, //bits 20:16 de instruction
    output reg  handler_Out
);


always @* begin
    if(opcode == 6'b000001)begin
        if(flag == 2'b01)begin //flag negative
            handler_Out <= 1'b0;
        end else begin
            handler_Out <= B_instr;
        end
    end else if(opcode == 6'b000111) begin
        if(flag == 2'b11 || flag == 2'b10)begin //flag negative
            handler_Out <= 1'b0;
        end else begin
            handler_Out <= B_instr;
        end
    end else begin
        handler_Out <= B_instr;
    end

    
end

endmodule




///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LogicBox(
    input Handler_B_instr,
    input unconditional_jump_signal,
    output reg logicbox_out
);

    always @* begin
        if((Handler_B_instr == 1'b1 && unconditional_jump_signal == 1'b1) || (Handler_B_instr == 1'b1 && unconditional_jump_signal == 1'b0) )begin
                logicbox_out <= 1'b1;
        end else begin
                logicbox_out <= 1'b0;
        end


    end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



module LogicBox_mux(
    input logicbox_out, // 1 bit
    input [31:0] IF_mux,
    input [31:0] nPC_input,  
    output reg [31:0] Logic_mux_output
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
    input [31:0] EX_TA,
    input [31:0] ID_TA,   
    input [31:0] rs,
    input TA_instruction, 
    input conditional_inconditional, // se anade esta senal pa determinar cual pasa entre ambas 
    output reg [31:0]mux_out
);

always @* begin  
    if(TA_instruction == 1'b1 && conditional_inconditional == 1'b1)begin
        mux_out <= EX_TA;   // cheuqear differencia entre id y EX TA


    end else if(TA_instruction == 1'b1 && conditional_inconditional == 1'b0) begin
      mux_out <= ID_TA;

    end else if(TA_instruction == 1'b0 && conditional_inconditional == 1'b1) begin
        mux_out = rs;
    end


end


endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module TargetAddressMux(
    input [31:0] concatenation,
    input [31:0] PC4_imm16,
    input conditional_inconditional,
    output reg [31:0] address
);

    always @* begin
        if(conditional_inconditional == 1'b1)begin
            address <= concatenation;
        end else begin
                address <= PC4_imm16;
        end

    end


endmodule