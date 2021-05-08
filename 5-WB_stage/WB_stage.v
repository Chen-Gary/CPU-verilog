/*
 * WB_stage
 * ------------------------------------------------
 * This module contains the following submodules:
 *   1. MEM/WB pipeline register (sequential)
 *        store the inputs from MEM_stage
 *   2. Write back data selector (combinational)
 *        select which data to be write back to register file
*/


module WB_stage (
    // input
    input CLK,

    // input from MEM_stage
    input RegWriteM,                // directly output to ID_stage
    input MemtoRegM,                // stored by local var
    input [5:0] ALUopM,             // stored by local var

    input [31:0] PCPlus4_in,        // stored by local var
    input [4:0] wb_addr_in,         // directly output to ID_stage

    input [31:0] ALUOut_in,         // stored by local var

    input [31:0] ReadData_in,       // stored by local var


    // output (to ID_stage)
    // directly output
    output reg RegWriteW,
    output reg [4:0] wb_addr_out,

    // output from "Write back data selector"
    output reg [31:0] wb_data_out
);

    // local var
    // local variables which store the input from previous stage
    reg MemtoRegW;
    reg [5:0] ALUopW;

    reg [31:0] PCPlus4;

    reg [31:0] ALUOut;

    reg [31:0] ReadData;


    // initialize control signals
    initial begin
        RegWriteW <= 1'b0;
    end


    /*
     * submodule: MEM/WB pipeline register
     * --------------------------------------------
     * sequential logic
     * store the inputs from previous stage (MEM_stage)
    */
    always @(posedge CLK) begin
        RegWriteW <= RegWriteM;
        MemtoRegW <= MemtoRegM;
        ALUopW <= ALUopM;

        PCPlus4 <= PCPlus4_in;
        wb_addr_out <= wb_addr_in;

        ALUOut <= ALUOut_in;

        ReadData <= ReadData_in;
    end


    /*
     * submodule: Write back data selector
     * --------------------------------------------
     * combinational logic
     * Input: MemtoRegW, ALUopW             (=> select signal)
     *        ALUOut, ReadData, PCPlus4     (=> data source)
     * Output: wb_data_out
    */
    always @(*) begin
        // check "MemtoRegW"
        if (MemtoRegW == 1'b0) begin
            wb_data_out <= ALUOut;
        end
        else if (MemtoRegW == 1'b1) begin
            wb_data_out <= ReadData;
        end

        // check "jal" instruction
        if (ALUopW == 6'b000011) begin
            wb_data_out <= PCPlus4;
        end
    end


endmodule
