/*
 * Change the input machine code in "InstructionRAM.v".
 *
 * The clock is 10 time unit per cycle.
*/


`include "CPU.v"


// test bench for CPU module
module test_CPU;
    
    reg CLK;


    CPU testCPU (
        .CLK (CLK)
    );


    // generate clock signal (T = 10)
    initial begin
        forever begin
        CLK <= 0;
        #5;
        CLK <= 1;
        #5;
        end
    end


    // the strategy to end the program is at the point where the CPU execute 32'hffffffff instruction
    // This "end program" logic is in "ID_stage.v"
    // terminate the program after ... cycles
    // initial begin
    //     #100;
    //     $finish;
    // end


    // generate vcd file (waveform)
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, test_CPU);
    end


endmodule
