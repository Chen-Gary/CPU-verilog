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


`include "4-MEM_stage/MainMemory.v"


module MEM_stage (
    // special input
    input terminateCPU,


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
    output reg [31:0] PC_next_jumpOrBranch,

    // output to ID_stage and EX_stage
    output reg flush
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
        flush     <= 1'b0;
    end


    /*
     * submodule: EX/MEM pipeline register
     * -------------------------------------------
     * sequential logic
     * store the inputs from previous stage (EX_stage)
    */
    always @(posedge CLK) begin
        RegWriteM <= RegWriteE;
        MemtoRegM <= MemtoRegE;
        MemWriteM <= MemWriteE;
        BranchM <= BranchE;
        JumpM <= JumpE;

        ALUopM <= ALUopE;
        WriteData <= WriteData_in;
        PCPlus4_out <= PCPlus4_in;

        PCBranch <= PCBranch_in;

        wb_addr_out <= wb_addr_in;

        ALUOut <= ALUOut_in;
    end
    // continuous assignment for the "directly" output
    assign ALUOut_out = ALUOut;


    /*
     * submodule: PCSrc control signal generator
     * -------------------------------------------
     * combinational logic
     * Input: JumpM, BranchM, ALUOut
     * Output: PCSrcM, flush
     *
     * generate PCSrcM signal, which is output to IF_stage
     * also generate the **flush** signal for ID and EX stages
    */
    always @(*) begin
        // by default, not branch or jump
        PCSrcM = 1'b0;
        flush  = 1'b0;

        // check Jump instructions
        if (JumpM == 1'b1) begin
            PCSrcM = 1'b1;
            flush  = 1'b1;
        end

        // check Branch instrctions
        if (BranchM==1'b1 && ALUOut==32'b1) begin
            PCSrcM = 1'b1;
            flush  = 1'b1;
        end
    end


    /*
     * submodule: PC_next_jumpOrBranch selector
     * -------------------------------------------
     * combinational logic
     * Input: JumpM, ALUOut, PCBranch
     * Output: PC_next_jumpOrBranch
    */
    always @(*) begin
        // by default, set to "PCBranch"
        // OR if (BranchM == 1'b1), set to "PCBranch"
        PC_next_jumpOrBranch = PCBranch;

        // if Jump instrcutions
        if (JumpM == 1'b1) begin
            PC_next_jumpOrBranch = ALUOut; // ALU calculates the jump target PC addr
        end
    end


    /*
     * submodule: MainMemory
     * -----------------------------------
     * instantiate "Data Memory"
    */
    MainMemory mainMemory (
        // special input
        .terminateCPU   (terminateCPU),

        // input
        .CLOCK          (CLK),
        .RESET          (1'b0),
        .ENABLE         (1'b1),
        .FETCH_ADDRESS  ( ALUOut >> 2 ),
        .EDIT_SERIAL    ( { MemWriteM, (ALUOut>>2), WriteData } ),

        // output
        .DATA           (ReadData_out)
    );



endmodule

