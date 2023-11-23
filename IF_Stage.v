module IF_Stage (
    input clk,
    input reset,
    input  [31:0] instruction_in,
    output reg [31:0] instruction_out
);

    // Internal signals and logic for the fetch stage
    // ...

    // Fetch stage logic
    always @(posedge clk) begin
       instruction_out <= instruction_in;

    end

endmodule