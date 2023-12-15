module IFID_Stage (
    input clk,
    input reset,
	input le,
	input [8:0] input_pc,
	input logicbox,
    input wire [31:0] instruction_in,
    output reg [31:0] instruction_out,
    output reg [25:0] address_26, // bit 25:0 de instruction 
    output reg [8:0] PC, //bit8:0  entrada desde PC
    output reg [25:21] rs, //bit 25:21
    output reg [20:16] rt, //bit 20:16
    output reg [15:0] imm16, //bit 15:0
    output reg [31:26] opcode, //bit 31:26
    output reg [15:11] rd //bit 15:11
    //output reg [16:0] control_signals_out
);

    always @(posedge clk or posedge reset) begin
		if (reset) begin
				instruction_out <= 32'b0;
                
                PC <= 9'b0;
                rs <= 6'b0;
                rt <= 6'b0;
                imm16 <= 16'b0;
                opcode <= 6'b0;
                rd <= 6'b0;
               address_26 <= 26'b0;
			end else if (le) begin
				instruction_out <= instruction_in; 
////////////////////////////////////////////////////////////////////////////////////////////////////////
                PC<= input_pc;
//        case(instruction_in[31:26])
//     // ADDIU
//     6'b001001: begin
//         opcode <= instruction_in[31:26];
//         imm16 <= instruction_in[15:0];
//         rs <= instruction_in[25:21];
//         rt <= instruction_in[20:16];
//     end
  
//     // LBU
//     6'b100100: begin
//         opcode <= instruction_in[31:26];
//         rs <= instruction_in[25:21];
//         rt <= instruction_in[20:16];
//         imm16 <= instruction_in[15:0];
//     end

//     // BGTZ
//     6'b000111: begin
//         opcode <= instruction_in[31:26];
//         rs <= instruction_in[25:21];
//         rt <= instruction_in[20:16];
//         imm16 <= instruction_in[15:0];
//     end

//     // SB
//     6'b101000: begin
//         opcode <= instruction_in[31:26];
//         rs <= instruction_in[25:21];
//         rt <= instruction_in[20:16];
//         imm16 <= instruction_in[15:0];
//     end

//     // JAL
//     6'b000011: begin
//         address_26 <= instruction_in[25:0];
//         opcode <= instruction_in[31:26];
//     end

//     // LUI
//     6'b001111: begin
//         opcode <= instruction_in[31:26];
//         rs <= instruction_in[25:21];
//         rt <= instruction_in[20:16];
//         imm16 <= instruction_in[15:0];
//     end

//     // B
//     6'b000100: begin
//         opcode <= instruction_in[31:26];
//         rs <= instruction_in[25:21];
//         rt <= instruction_in[20:16];
//         imm16 <= instruction_in[15:0];
//     end

//     // I
//     6'b000001: begin
//         // BGEZ
//         if(instruction_in[20:16] == 5'b00001) begin
//             opcode <= instruction_in[31:26];
//             rs <= instruction_in[25:21];
//             rt <= instruction_in[20:16];
//             imm16 <= instruction_in[15:0];
//         end
//     end

//     // R
//     6'b000000: begin
//         // JR
//         if(instruction_in[5:0] == 6'b001000) begin
//             opcode <= instruction_in[31:26];
//             rd <= instruction_in[15:11];
//             rs <= instruction_in[25:21];
//             rt <= instruction_in[20:16];
//         // SUBU
//         end else if(instruction_in[5:0] == 6'b100011) begin
//             opcode <= instruction_in[31:26];
//             rd <= instruction_in[15:11];
//             rs <= instruction_in[25:21];
//             rt <= instruction_in[20:16];
                 
//         // ADDU
//         end else if(instruction_in[5:0] == 6'b100001) begin
//             opcode <= instruction_in[31:26];
//             rd <= instruction_in[15:11];
//             rs <= instruction_in[25:21];
//             rt <= instruction_in[20:16];
//             PC <= input_pc;
//         // NOP
//         end else if(instruction_in[25:0] == 26'b0) begin
//             rs <= 6'b0;
//             rt <= 6'b0;
//             imm16 <= 16'b0;
//             opcode <= 6'b0;
//             rd <= 6'b0;
//             address_26 <= 26'b0;
//         end
//     end

//     default: begin
//         rs <= 6'b0;
//         rt <= 6'b0;
//         imm16 <= 16'b0;
//         opcode <= 6'b0;
//         rd <= 6'b0;
//         address_26 <= 26'b0;
//     end
// endcase



                //////////////////////////////////////////////////////////////////////////////////////
             if(instruction_in[31:26] == 6'b0) begin
                    opcode <= instruction_in[31:26];
                    rd <= instruction_in[15:11];
                    rs <= instruction_in[25:21];
                    rt <= instruction_in[20:16];
                   

                    address_26 <= 26'b0;
                    imm16 <= 16'b0;
                end else if(instruction_in[31:26] == 6'b000011) begin
                    address_26 <= instruction_in[25:0];
                    opcode <= instruction_in[31:26];

                   
                     rd <= 6'b0;
                      rs <= 6'b0;
                    rt <= 6'b0;
                    imm16 <= 16'b0;

                end else begin
                    opcode <= instruction_in[31:26];
                    rs <= instruction_in[25:21];
                    rt <= instruction_in[20:16];
                    imm16 <= instruction_in[15:0];

                   
                    address_26 <= 26'b0;
                     rd <= 6'b0;
                end



        end
    end
	
endmodule