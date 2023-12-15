module DataMemory (
output reg [31:0] DataOut, 
input Enable, ReadWrite, SE, 
input [1:0] Size, 
input [8:0] Address, 
input [31:0] DataIn
);
reg [7:0] Mem[0:511]; //512 localizaciones de 32 bits
always @ (*)
	if (Enable)
		if (ReadWrite) begin
			case (Size)
				2'b00:
					Mem[Address] <= DataIn[7:0];
				2'b01:
					begin
						Mem[Address] <= DataIn[15:8];
						Mem[Address+1] <= DataIn[7:0];
					end
				2'b10:
					begin
						Mem[Address] <= DataIn[31:24]; 
						Mem[Address+1] <= DataIn[23:16]; 
						Mem[Address+2] <= DataIn[15:8];
						Mem[Address+3] <= DataIn[7:0];
					end
			endcase
		end else 
			case (Size)
				2'b00: 
					if (!SE) begin
					DataOut <= {24'b000000000000000000000000, Mem[Address]};
					end else if (Mem[Address][7] == 1'b1) begin
					DataOut <= {{24{1'b1}}, Mem[Address]};  
					end else 
					DataOut <= {{24{1'b0}}, Mem[Address]}; 
				2'b01:
					if (!SE) begin
					DataOut <= {16'b0000000000000000, Mem[Address], Mem[Address+1]};
					end else if (Mem[Address][7] == 1'b1) begin
					 DataOut <= {{16{1'b1}}, Mem[Address], Mem[Address+1]}; 
					end else 
					DataOut <= {{16{1'b0}}, Mem[Address], Mem[Address+1]};
				2'b10:
					DataOut <= {Mem[Address], Mem[Address+1], Mem[Address+2], Mem[Address+3]};
				2'b11:
					DataOut <= {Mem[Address], Mem[Address+1], Mem[Address+2], Mem[Address+3]};
			endcase
endmodule
