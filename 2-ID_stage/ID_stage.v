/*
 * ID_stage
 * ------------------------------------------------
 * This module contains the following submodules:
 *    1. IF/ID pipeline register (sequential)
 *         store the inputs from IF_stage
 *    2. Instruction parser (combinational)
 *         parse the instruction; the output will be used in the following 3 submodules
 *    3. imm-extender (combinational)
 *         zero/sign extend
 *    4. Register File
 *         - Read part (combinational)
 *         - Write part (sequential, need to delay)
 *    5. Control Unit (combinational)
 *         Decode the instruction to generate control signals
*/

// remark: 1. initialize register file!!

module ID_stage (
    // input
    input CLK,

    // input from IF_stage
    input [31:0] instruction_in,  // stored by local var
    input [31:0] PCPlus4_in,      // directly output to next stage

    // input from WB_stage (write back to register file)
    input RegWriteW,
    input [4:0] wb_addr,
    input [31:0] wb_data,

    // output
    // directly output
    output reg [31:0] PCPlus4_out,

    // output from imm-extender submodule
    output reg [31:0] imm_signExtended,
    output reg [31:0] imm_zeroExtended,

    // "directly" output (after parsing the instruction)
    output [4:0] rt_addr_out,
    output [4:0] rd_addr_out,

    // output from Register File - Read part
    output [31:0] rs_reg;
    output [31:0] rt_reg;

    // output from Control Unit
    output reg RegWriteD,
    output reg MemtoRegD,
    output reg MemWriteD,
    output reg BranchD,
    output reg JumpD,
    output reg [5:0] ALUopD;
    output reg [5:0] ALUfunctD;
    output reg RegDstD;
);

    // local var
    reg [31:0] instruction;
    // parsing the instruction
    wire [5:0] op, funct;
    wire [4:0] rs_addr, rt_addr, rd_addr;
    wire [4:0] shamt;
    wire [15:0] imm_origin;
    wire [25:0] address_Jtype;

    // register file
    reg [31:0] [31:0] registerFile; 


    // initialize register file
    integer i;
    initial begin
        for (i=0; i<32; i=i+1) begin
            registerFile [i] = 32'b0;
        end
    end



    /*
     * submodule: IF/ID pipeline register
     * --------------------------------------
     * sequential logic
     * store the two inputs from IF_stage
    */
    always @(posedge CLK) begin
        instruction <= instruction_in;
        PCPlus4_out <= PCPlus4_in;
    end


    /*
     * submodule: Instruction parser
     * ---------------------------------------
     * combinational logic
     * Input: 32-bit instruction
     * Output: several small segments of the instruction
     *
     * parse the instruction
     * the output will be used in other submodules (Control Unit, Register File - Read Part, imm-extender)
    */
    assign op = instruction [31:26];
    assign rs_addr = instruction [25:21];
    assign rt_addr = instruction [20:16];
    assign rd_addr = instruction [15:11];
    assign shamt = instruction [10:6];
    assign funct = instruction [5:0];

    assign imm_origin = instruction [15:0];

    assign address_Jtype = instruction [25:0];


    /*
     * submodule: imm-extender
     * --------------------------------------------
     * combinational logic
     * Input: imm_origin
     * Output: imm_signExtended, imm_zeroExtended
    */
    always @(*) begin
        // sign extend imm
        if (imm_origin[15] == 1'b0) imm_signExtended = { {16{1'b0}}, imm_origin };
        else imm_signExtended = { {16{1'b1}}, imm_origin };
        // zero extend imm
        imm_zeroExtended = { {16{1'b0}}, imm_origin };
    end


    /*
     * (not in the above comment)
     * submodule: output rt_addr_out and rd_addr_out
     * ------------------------------------------------
     * combinational logic
    */
    assign rt_addr_out = rt_addr;
    assign rd_addr_out = rd_addr;


    /*
     * submodule: Register File - Read part
     * -----------------------------------------------
     * combinational logic
     * Input: rs_addr, rt_addr
     * Output: rs_reg, rt_reg (output of ID_stage module)
    */
    assign rs_reg = registerFile [ $unsigned(rs_addr) ];
    assign rt_reg = registerFile [ $unsigned(rt_addr) ];


    /*
     * submodule: Register File - Write part
     * -----------------------------------------------
     * sequential logic, need to delay
     * Input: RegWriteW, wb_addr, wb_data
     * No output
     *
     * Write data back to registerFile
    */
    always @(posedge CLk) begin
        #1; // wait for the WB_stage to be ready (wait for the three inputs from WB_stage to be updated)
        if (RegWriteW == 1'b1) begin
            registerFile [ $unsigned(wb_addr) ] <= wb_data;
        end
    end


    /*
     * submodule: Control Unit
     * -----------------------------------------------
     * combinational logic
     * Input: op, funct
     * Ouput: 8 control signals (output of ID_stage module)
    */
    always @(*) begin

        // initialize the 8 control signals (all to zero)
        RegWriteD = 1'b0;
        MemtoRegD = 1'b0;
        MemWriteD = 1'b0;
        BranchD   = 1'b0;
        JumpD     = 1'b0;
        ALUopD    = op;
        ALUfunctD = funct;
        RegDstD   = 1'b0;

        // set the control signals basing on the instruction type (op, funct)
        // Since all the control signals have already been initialized to 0,
        // we only set those signals to 1, if needed.
        // (In addition, ALUop and ALUfunct have already been set to correct value)
        
        // lw

        // sw

        // add

        // addu

        // addi

        // addiu

        // sub

        // subu

        // and

        // andi

        // nor

        // or

        // ori

        // xor

        // xori

        // sll

        // sllv

        // srl

        // srlv

        // sra

        // srav

        // beq

        // bne

        // slt

        // j

        // jr

        // jal

    end


    
endmodule


