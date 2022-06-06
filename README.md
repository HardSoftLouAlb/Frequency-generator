# Frequency generator

This project takes place in the course of Hardware & Software Platforms given by Pr. Valderrama.
Made by Louis Aromatario & Alberto Badilini
2021-2022, FPMS (UMons)

## Reading before realisation



The objective of the project is to create an hardware driver and a application program for a frequency generator.

The FPGA receives as an input a value from 0 to 255 as a std_logic_vector and must generate a frequency between 50Hz and 50kHz; the value 0 corresponds to the minimum period of 20µs (f=50kHz) and 255 corresponds to the maximum period of 20 ms (f=50Hz). Every value n corresponds to a period of 20µs + n*TIMESTEP where the TIMESTEP is equal to (20ms-20µs)/255=78µs.

Seeing that we have an internal clock of 50Mhz (period=20ns) we can convert all the time values in pure clock counts so they become:
STEP= 78µs/20ns=3900 ;
MINCOUNT=20µs/20ns=1000 ;
MAXCOUNT= 20ms/20ns=1000000

The output pin will only stay high for one cycle of the 50MHz clock every period. This function is managed by the FreqOut.VHDL file, while the FreqOut_TB.VHDL is used as a testbench.

The input registers (the one for the input value and the one for the enable pin that must be set to generate the frequency) are controlled by the software driver in the processor that, after taking the address of the registers, writes the desired value for the enable and for the period (still using a number from 0 to 255 as explained before) in the correct place. Those functions are managed by the main.c file.

