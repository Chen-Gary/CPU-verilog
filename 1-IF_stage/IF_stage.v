`include "1-IF_stage/InstructionRAM.v"

module IF_stage (
    input CLK,

    // set by MEM_stage
    input PCSrc,
    input [31:0] PC_next_jumpOrBranch,

    output [31:0] instruction,
    output [31:0] PCPlus4
);

    reg [31:0] currentPC;

    wire [31:0] PC_next_plus4;


    // instantiate "Instruction Memory"
    InstructionRAM instructionRAM (
        .CLOCK (CLK),
        .RESET (1'b0),
        .ENABLE (1'b1),
        .FETCH_ADDRESS (currentPC >> 2),

        .DATA (instruction)
    );


    // initialize `currentPC`
    // PC always starts from 0
    initial begin
        currentPC <= 32'b0 - 32'd4;
    end

    assign PC_next_plus4 = currentPC + 32'd4; // PC self plus 4
    assign PCPlus4 = PC_next_plus4;


    // update PC when posedge
    always @(posedge CLK) begin
        #1;  // wait for MEM_stage (`PCSrc` and `PC_next_jumpOrBranch`) to be ready
        if (PCSrc == 1'b1) begin
            currentPC <= PC_next_jumpOrBranch;
        end
        else begin
            currentPC <= PC_next_plus4;
        end
    end


endmodule