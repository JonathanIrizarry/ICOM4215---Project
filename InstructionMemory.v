module instr_mem (
    output reg [31:0] DataOut,
    input [8:0] Address
);

    reg [7:0] Mem[0:511]; //512 localizaciones de 8 bits
    
    always @ (Address)
        DataOut <= {Mem[Address], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};
    
endmodule