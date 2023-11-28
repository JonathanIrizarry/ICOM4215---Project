module instr_mem (
    output reg [31:0] DataOut,
    input  [8:0] Address,
    input [31:0] instr
);

    reg [7:0] Mem[0:511]; //512 localizaciones de 8 bits
    
    always @ (Address)begin
        
        if(instr == 0) begin
        DataOut = 32'b0;
        // $display("instr = %d" , instr);
    end else begin
         DataOut = {Mem[Address], Mem[Address + 1], Mem[Address + 2], Mem[Address + 3]};
        //   $display("dataout = %d" , DataOut);
    end
    end
endmodule 