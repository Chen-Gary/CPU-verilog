/*
 * EX_stage
 * ------------------------------------------------
 * This module contains the following submodules:
 *    1. ID/EX pipeline register (sequential)
 *         store the inputs from ID_stage (either store in a local var or directly to output)
 *    2. Branch target calculator (combinational)
 *    3. Write back addr selector (combinational)
 *    4. ALU (combinational)
*/


module EX_stage (
    // input
    input CLK,

    // input from ID_stage
    input [31:0] PCPlus4_in,            // stored by local var; used in "Branch target calculator"

    input [31:0] imm_signExtended_in,   // stored by local var
    input [31:0] imm_zeroExtended_in,   // stored by local var

    input [4:0] rt_addr_in,             // stored by local var; used in "Write back addr selector"
    input [4:0] rd_addr_in,             // stored by local var; used in "Write back addr selector"
    input [4:0] shamt_in,               // stored by local var

    input [31:0] rs_reg_in,             // stored by local var
    input [31:0] rt_reg_in,             // stored by local var

    input RegWriteD,                    // directly output to next stage
    input MemtoRegD,                    // directly output to next stage
    input MemWriteD,                    // directly output to next stage
    input BranchD,                      // directly output to next stage
    input JumpD,                        // directly output to next stage
    input [5:0] ALUopD,                 // stored by local var
    input [5:0] ALUfunctD,              // stored by local var
    input RegDstD,                      // stored by local var


    // output
    // directly output
    output reg RegWriteE,
    output reg MemtoRegE,
    output reg MemWriteE,
    output reg BranchE,
    output reg JumpE,

    // "directly" output
    output [5:0] ALUopE,           // output "op" because WB_stage need to check whether it encounter "jal" instruction
    output [31:0] WriteData_out,   // the data to be written into MainRAM in MEM_stage ("sw" instrcution)

    // output from Branch target calculator
    output [31:0] PCBranch_out,

    // output from Write back addr selector
    output reg [4:0] wb_addr_out,

    // output from ALU
    output reg [31:0] ALUOut    // ALU only output one 32-bit result, no flag will be output
);
    
    // local var
    // local variables which store the input from previous stage
    reg [31:0] PCPlus4;

    reg [31:0] imm_signExtended;
    reg [31:0] imm_zeroExtended;

    reg [4:0] rt_addr;
    reg [4:0] rd_addr;
    reg [4:0] shamt;

    reg [31:0] rs_reg;
    reg [31:0] rt_reg;

    reg [5:0] op;
    reg [5:0] funct;
    reg RegDstE;


    /*
     * submodule: ID/EX pipeline register
     * --------------------------------------
     * sequential logic
     * store the inputs from previous stage (ID_stage)
    */
    always @(posedge CLK) begin
        PCPlus4 <= PCPlus4_in;

        imm_signExtended <= imm_signExtended_in;
        imm_zeroExtended <= imm_zeroExtended_in;

        rt_addr <= rt_addr_in;
        rd_addr <= rd_addr_in;
        shamt <= shamt_in;

        rs_reg <= rs_reg_in;
        rt_reg <= rt_reg_in;

        RegWriteE <= RegWriteD;
        MemtoRegE <= MemtoRegD;
        MemWriteE <= MemWriteD;
        BranchE <= BranchD;
        JumpE <= JumpD;
        op <= ALUopD;
        funct <= ALUfunctD;
        RegDstE <= RegDstD;
    end
    // continuous assignment for two "directly" output
    assign ALUopE = op;
    assign WriteData_out = rt_reg;

    



endmodule

