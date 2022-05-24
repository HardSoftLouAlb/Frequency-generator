# Frequency-generator

The objective of the project is to create a driver for a frequency generator. 
The FPGA receives as an input a value from 0 to 255 as a std_logic_vector and must generate a frequency between 50Hz and 50kHz; the value 0 corresponds to the minimum period of 20us (f=50kHz) and 255 corresponds to the maximum period of 20 ms (f=50Hz). Every value n corresponds to a period of 20us + n*TIMESTEP where the TIMESTEP is equal to (20ms-20us)/256=78us.

 As soon as we have an internal clock of 50Mhz (period=20ns) we can convert all the time values in pure clock counts so they become:
STEP= 78us/20ns=3900
MINCOUNT=20us/20ns=1000
MAXCOUNT= 20ms/20ns=1000000

The output pin then stays high for one clock cycle every period.

The input registers (the one for the input value and the one for the enable pin that must be set to generate the frequency) are controlled by the software driver in the processor that, after taking the address of the registers, writes the desired value for the enable and for the period (still using a number from 0 to 255 as explained before) in the correct place.

