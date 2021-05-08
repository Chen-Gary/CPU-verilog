`include "4-MEM_stage/MainMemory.v"

/*
 * MEM_stage
 * ------------------------------------------------
 * This module contains the following submodules:
 *    1. EX/MEM pipeline register (sequential)
 *         store the inputs from EX_stage (either store in a local var or directly to output)
 *    2. PCSrc control signal generator (combinational)
 *         generate PCSrcM signal, which is output to IF_stage
 *    3. PC_next_jumpOrBranch selector (combinational)
 *         set the jump/branch target basing on the instruction type (Branch, Jump signal),
 *         and output to IF_stage
 *    4. MainMemory
 *         MainMemory.v
*/


// modify the "MainMemory.v" by adding **delay**!
// your CPU should display the top 30 rows of the Main Memory in the screen.


module MEM_stage (
    // input
    input CLK,

    // input from EX_stage
    input RegWriteE,                // directly output to next stage
    input MemtoRegE,                // directly output to next stage
    input MemWriteE,                // stored by local var; used in "MainMemory"
    input BranchE,                  // stored by local var; used in "PCSrc control signal generator"
    input JumpE,                    // stored by local var; used in "PCSrc control signal generator"

    input [5:0] ALUopE,             // directly output to next stage (WB_stage need to check whether it encounter "jal" instruction)
    input [31:0] WriteData_in,      // stored by local var ("sw" instrcution)
    input [31:0] PCPlus4_in,        // directly output to next stage (for "jal")

    input [31:0] PCBranch_in,       // stored by local var; used in "PC_next_jumpOrBranch selector"

    input [4:0] wb_addr_in,         // directly output to next stage

    input [31:0] ALUOut_in,         // stored by local var


    // output
    // output to WB_stage
    // directly output
    output reg RegWriteM,
    output reg MemtoRegM,
    output reg [5:0] ALUopM,

    output reg [31:0] PCPlus4_out,
    output reg [4:0] wb_addr_out,

    // "directly" output
    output [31:0] ALUOut_out,

    // output from "MainMemory"
    output [31:0] ReadData_out,

    // output to IF_stage
    // output from "PCSrc control signal generator"
    output reg PCSrcM,

    // output from "PC_next_jumpOrBranch selector"
    output reg [31:0] PC_next_jumpOrBranch
);

    // local var
    // local variables which store the input from previous stage
    reg MemWriteM;
    reg BranchM;
    reg JumpM;

    reg [31:0] WriteData;

    reg [31:0] PCBranch;

    reg [31:0] ALUOut;


    // initialize control signals
    initial begin
        RegWriteM <= 1'b0;
        MemtoRegM <= 1'b0;
        ALUopM    <= 6'b0;
    end


    /*
     * 
    */


    
endmodule

