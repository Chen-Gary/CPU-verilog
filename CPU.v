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


    IF_stage if_stage (
        .CLK (CLK),

        .PCSrc (1'b0), // later...
        .PC_next_jumpOrBranch (32'b0), // later...

        .instruction(instruction_IF_ID),
        .PCPlus4(PCPlus4_IF_ID)
    );
    // ID_stage id_stage
    // EX_stage ex_stage
    // MEM_stage mem_stage
    // WB_stage wb_stage
    
endmodule
