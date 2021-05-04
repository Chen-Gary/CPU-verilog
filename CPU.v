/*
 * Overall implementation:
 *
 * There are 5 modules correspond to the 5 the stages.
 * These 5 modules are posedge triggered (sequential logic) 
 *     ==> which means the functionalities of these 5 modules are more like the **pipeline registers**.
 * 
 * Inside those 5 modules/stages, there are several other modules,
 * which are not edge triggered (comninational logic).
 *
 * e.g.
 * `alu` module is instantiated inside `EX_stage` module
*/


/*
 * Five stages (module name):
 *   1.  IF_stage: Instruction fetch from instruction memory
 *   2.  ID_stage: Instruction decode & register read
 *   3.  EX_stage: Execute operation or calculate address
 *   4. MEM_stage: Access data memory operand
 *   5.  WB_stage: Write the result back to register
 *
 * Note that These 5 modules are instantiated in `cpu` module.
*/


/*
 * Module Dependency
 *
 * Parent Module |
 * --------------+----------------------------
 *      IF_stage |
 *      ID_stage |
 *      EX_stage |
 *     MEM_stage |
 *      WB_stage |
*/


/*
 * About the control signals:
 * 
 * 1. RegWrite
 *      whether to write back to register file
 *      - 0: no write back
 *      - 1: need to write back
 *
 * 2. MemtoReg
 *      select which data to write back
 *      - 0: Output of ALU
 *      - 1: Data read from the memory
 *
 * 3. MemWrite
 *      whether to write to MainRAM
 *      - 0: do not write to MainRAM
 *      - 1: need to write to MainRAM
 *
 * 4. Branch
 *      - 0: is not branch instruction
 *      - 1: is branch instruction
 *
 * 5. Jump
 *      - 0: is not jump instruction
 *      - 1: is jump instruction
 *
 * 6. ALUop    (6-bit)
 * 7. ALUfunct (6-bit)
 *      the above two control signals together determine which instruction ALU should perform
 *
 * 8. RegDst
 *      determine the wb_addr
 *      - 0: wb_addr = rt_addr
 *      - 1: wb_addr = rd_addr
*/


`include "1-IF_stage/IF_stage.v"
`include "2-ID_stage/ID_stage.v"
`include "3-EX_stage/EX_stage.v"
`include "4-MEM_stage/MEM_stage.v"
`include "5-WB_stage/WB_stage.v"


module CPU (
    input CLK
);

    // variables connecting IF/ID stages
    wire [31:0] instruction_IF_ID;
    wire [31:0] PCPlus4_IF_ID;

    // variables connecting ID/EX stages
    wire [31:0] PCPlus4_ID_EX;
    wire [31:0] imm_signExtended_ID_EX;
    wire [31:0] imm_zeroExtended_ID_EX;
    wire [ 4:0] rt_addr_ID_EX;
    wire [ 4:0] rd_addr_ID_EX;
    wire [ 4:0] shamt_ID_EX;
    wire [31:0] rs_reg_ID_EX;
    wire [31:0] rt_reg_ID_EX;
    wire        RegWrite_ID_EX;
    wire        MemtoReg_ID_EX;
    wire        MemWrite_ID_EX;
    wire        Branch_ID_EX;
    wire        Jump_ID_EX;
    wire [ 5:0] ALUop_ID_EX;
    wire [ 5:0] ALUfunct_ID_EX;
    wire        RegDst_ID_EX;


    // instanciate the five stages
    IF_stage if_stage (
        // input
        .CLK                    (CLK),

        .PCSrc                  (1'b0), // later...MEM_stage
        .PC_next_jumpOrBranch   (32'b0), // later...MEM_stage

        // output (to ID_stage)
        .instruction            (instruction_IF_ID),
        .PCPlus4                (PCPlus4_IF_ID)
    );
    
    ID_stage id_stage (
        // input
        .CLK               (CLK),

        .instruction_in    (instruction_IF_ID),
        .PCPlus4_in        (PCPlus4_IF_ID),

        .RegWriteW         (1'b0),// later...WB_stage
        .wb_addr           (5'b0),// later...WB_stage
        .wb_data           (32'b0),

        // output (to EX_stage)
        .PCPlus4_out       (PCPlus4_ID_EX),

        .imm_signExtended  (imm_signExtended_ID_EX),
        .imm_zeroExtended  (imm_zeroExtended_ID_EX),

        .rt_addr_out       (rt_addr_ID_EX),
        .rd_addr_out       (rd_addr_ID_EX),
        .shamt_out         (shamt_ID_EX),

        .rs_reg            (rs_reg_ID_EX),
        .rt_reg            (rt_reg_ID_EX),

        .RegWriteD         (RegWrite_ID_EX),
        .MemtoRegD         (MemtoReg_ID_EX),
        .MemWriteD         (MemWrite_ID_EX),
        .BranchD           (Branch_ID_EX),
        .JumpD             (Jump_ID_EX),
        .ALUopD            (ALUop_ID_EX),
        .ALUfunctD         (ALUfunct_ID_EX),
        .RegDstD           (RegDst_ID_EX)
    );

    // EX_stage ex_stage
    // MEM_stage mem_stage
    // WB_stage wb_stage
    
endmodule
