/*
 * IF_stage
 * ------------------------------------------------
 * This module contains the following submodules:
 *    1. PC updater (sequential)
 *         update the PC address so that the next instruction can be fetched later in **this** stage
 *    2. PCPlus4 adder (combinational)
 *         always output current PC+4
 *    3. Instruction Memory
 *         InstructionRAM.v (sequential)
*/


`include "1-IF_stage/InstructionRAM.v"


module IF_stage (
    // input
    input CLK,

    // input from MEM_stage
    input PCSrc,                        // not stored by local var or be outputed; directly used in "PC updater"
    input [31:0] PC_next_jumpOrBranch,  // not stored by local var or be outputed; directly used in "PC updater"


    // output (to ID_stage)
    output [31:0] instruction,
    output [31:0] PCPlus4
);

    // local var
    reg [31:0] currentPC;

    wire [31:0] PC_next_plus4;


    // initialize `currentPC`
    // PC always starts from 0
    initial begin
        currentPC <= 32'b0 - 32'd4;
    end


    /*
     * submodule: PC updater
     * ---------------------------------------
     * sequential logic
     * Input: PCSrc
     *        PC_next_plus4, PC_next_jumpOrBranch
     * Update (Output): currentPC
     *
     * update PC when posedge
    */
    always @(posedge CLK) begin
        #1;  // wait for MEM_stage (`PCSrc` and `PC_next_jumpOrBranch`) to be ready
        if (PCSrc == 1'b1) begin
            currentPC <= PC_next_jumpOrBranch;
        end
        // by default (PCSrc == 1'b0)
        else begin
            currentPC <= PC_next_plus4;
        end
    end


    /*
     * submodule: PCPlus4 adder
     * ---------------------------------------
     * combinational logic
     *
     * always output current PC+4
    */
    assign PC_next_plus4 = currentPC + 32'd4;   // PC self plus 4
    assign PCPlus4 = PC_next_plus4;             // continuous assignment for the output "PCPlus4"


    /*
     * submodule: Instruction Memory
     * ---------------------------------------
     * instantiate "Instruction Memory"
    */
    InstructionRAM instructionRAM (
        .CLOCK (CLK),
        .RESET (1'b0),
        .ENABLE (1'b1),
        .FETCH_ADDRESS (currentPC >> 2),

        .DATA (instruction)
    );

endmodule
