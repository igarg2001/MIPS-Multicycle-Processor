# MIPS-Multicycle-Processor
Implementation of 16-bit MIPS Multicycle Processor (with datapath and control) using Verilog. <br />
The instruction set can be found [here](https://drive.google.com/file/d/1NesGaZKVigRQUhYskqFTJvKOct304K8w/view?usp=sharing)

Made as part of the Course CSF342: Computer Architecture at BITS Pilani

## Issues with the code 
(as of 25/04/2022)
1. Branch equal does not work
2. Issues with testbench displays, the first testcase gets repeated 4 times, leading to a delay of 3 in subsequent testcases. Current workaround is to add 3 dummy testcases in the beginning.
3. Issues with $readmemh function, an instruction was being read twice for one testcase, leading to a delay of 1 in subsequent testcases. Current workaround is to repeat the testcase for the repeating instruction.

## Collaborators
1. Jagrit Lodha (2019A3PS0165P)
2. Avi Tanwar (2019A8PS0332P)
3. Ishan Garg (2019A7PS0034P)
