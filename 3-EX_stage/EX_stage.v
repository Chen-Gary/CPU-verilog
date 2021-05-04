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
    output [31:0] PCPlus4_out,     // "jal" may need to save this "PCPlus4_out" to $ra in WB_stage

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


    // initialize control signals
    initial begin
        RegWriteE <= 1'b0;
        MemtoRegE <= 1'b0;
        MemWriteE <= 1'b0;
        BranchE   <= 1'b0;
        JumpE     <= 1'b0;
    end


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
    // continuous assignment for three "directly" outputs
    assign ALUopE = op;
    assign WriteData_out = rt_reg;
    assign PCPlus4_out = PCPlus4;


    /*
     * submodule: Branch target calculator
     * ------------------------------------------
     * combinational logic
     * Input: imm_signExtended, PCPlus4
     * Output: PCBranch_out
     *
     * Calculate the branch target PC value, if the branch is taken
    */
    assign PCBranch_out = PCPlus4 + ( imm_signExtended << 2 );


    /*
     * submodule: Write back addr selector
     * ------------------------------------------
     * combinational logic
     * Input: rt_addr, rd_addr, RegDstE, op (because of "jal" instruction)
     * Output: wb_addr_out
     * 
     * Select the addr of register file where the data is going to be write back in WB_stage
    */
    always @(*) begin
        // initialize
        wb_addr_out = 5'b0;

        if (RegDstE == 1'b0) begin
            wb_addr_out = rt_addr;
        end
        else if (RegDstE == 1'b1) begin
            wb_addr_out = rd_addr;
        end

        // check "jal" instrcution
        if (op == 6'b000011) begin
            wb_addr_out = 5'b11111;   // set to the addr of $ra
        end
    end


    /*
     * submodule: ALU
     * ------------------------------------------
     * combinational logic
     * Input: op, funct    (to identify the instrcution)
     *        rs_reg,                                             (1st operand of ALU)
     *        rt_reg, imm_signExtended, imm_zeroExtended, shamt   (2nd operand of ALU)
     * Output: ALUOut
    */
    always @(*) begin
        // initialize
        ALUOut = 32'b0;

        // identify and execute the instruction
        // lw
        if (op==6'b100011) begin 

        end
        // sw
        else if (op==6'b101011) begin
            
        end
        // add
        else if (op==6'b000000 && funct==6'b100000) begin
            
        end
        // addu
        else if (op==6'b000000 && funct==6'b100001) begin
            
        end
        // addi
        else if (op==6'b001000) begin
            
        end
        // addiu
        else if (op==6'b001001) begin
            
        end
        // sub
        else if (op==6'b000000 && funct==6'b100010) begin
            
        end
        // subu
        else if (op==6'b000000 && funct==6'b100011) begin
            
        end
        // and
        else if (op==6'b000000 && funct==6'b100100) begin
            
        end
        // andi
        else if (op==6'b001100) begin
            
        end
        // nor
        else if (op==6'b000000 && funct==6'b100111) begin
            
        end
        // or
        else if (op==6'b000000 && funct==6'b100101) begin
            
        end
        // ori
        else if (op==6'b001101) begin
            
        end
        // xor
        else if (op==6'b000000 && funct==6'b100110) begin
            
        end
        // xori
        else if (op==6'b001110) begin
            
        end
        // sll
        else if (op==6'b000000 && funct==6'b000000) begin
            
        end
        // sllv
        else if (op==6'b000000 && funct==6'b000100) begin
            
        end
        // srl
        else if (op==6'b000000 && funct==6'b000010) begin
            
        end
        // srlv
        else if (op==6'b000000 && funct==6'b000110) begin
            
        end
        // sra
        else if (op==6'b000000 && funct==6'b000011) begin
            
        end
        // srav
        else if (op==6'b000000 && funct==6'b000111) begin
            
        end
        // beq
        else if (op==6'b000100) begin
            
        end
        // bne
        else if (op==6'b000101) begin
            
        end
        // slt
        else if (op==6'b000000 && funct==6'b101010) begin
            
        end
        // j
        else if (op==6'b000010) begin
            
        end
        // jr
        else if (op==6'b000000 && funct==6'b001000) begin
            
        end
        // jal
        else if (op==6'b000011) begin
            
        end
        // Unrecognized instruction
        else begin
            $display("Unrecognized instruction: %b (ID_stage)", instruction);
            //$finish;
        end
    end



endmodule

