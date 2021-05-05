test_CPU:
	iverilog -o test_CPU test_CPU.v

# clean:
# 	rm -rf ./test_CPU


# How to run this program

## In Linux
## ```
##   make                                 # generate executable, named "test_CPU"
##
##   ./test_CPU                           # run the executable, and a file named "wave.vcd" will be generated
##
##   gtkwave wave.vcd                     # see the waveform
##
## ```

## In Windows
## ```
##   iverilog -o test_CPU test_CPU.v      # compile the source code; one "executable" named "test_CPU" will be generated
##
##   vvp test_CPU                         # execute the "executable", and a file named "wave.vcd" will be generated
##
##   gtkwave wave.vcd                     # see the waveform
##
## ```
