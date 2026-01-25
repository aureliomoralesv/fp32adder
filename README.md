[![Librelane Digital Flow (UNIC-CASS)](https://github.com/unic-cass/unic-cass-wrapper/actions/workflows/digital-flow.yaml/badge.svg?branch=dev&event=push)](https://github.com/unic-cass/unic-cass-wrapper/actions/workflows/digital-flow.yaml)

# VLSI implementation of a simple 32-bit floating-point adder based on IEEE 754 using open-source software tools 

| :exclamation: Important Note            |
|-----------------------------------------|

## Description of the project 

The intended design to be integrated on a VLSI chip using IHP SG13G2 PDK is a basic 32-bit floating point adder based on IEEE 754. All the modules will be purely digital. According to the block diagram provided, the "reset" input asynchronously resets the entire design, then after signal "go" is active (from high to low), two 32-bit floating-point numbers are loaded into registers REG_A and REG_B in a serial fashion using one single input "inpab" (first REG_A, then REG_B, both from LSB to MSB), using output "shift" for 64 clock pulses, assuming that REG_A is greater than REG_B, and the CONTROL block, based on a Finite State Machine (FSM) Moore machine, sends an receives several signals to/from others block, and finally the result is generated on REG_C. REG_C is shifted out to the left via the output "reg_c" while "done" signal is high for 32 clock pulses.

The design is specified using a behavioral and structural level description of a controller and datapath based 
on the FSM+D model (Finite State Machine + Datapath), and using the Verilog hardware description language. 
The 32-bit floating point adder circuit will not perform rounding or truncation of the result. It will always be 
assumed that the exponent of the REG_A register will be greater than or equal to the exponent of the REG_B register. 

The circuit design will be implemented hierarchically, using the Verilog hardware description language, with 
a top-level file (add_float), and 10 modules (BIG_ALU, CONTROL, EXP_DIF, EXPO, MANT, REG_A, REG_B, REG_C, SMALL_ALU, 
and TEMP). The BIG_ALU block takes care of the addition of the fraction part of each input register REG_A and REG_B. 

The CONTROL block implements a Moore state machine that takes care of the sequencing of control signals to make sure the 
floating-point addition result is consistent. EXP_DIF, is a register that loads the difference of REG_A and REG_B's exponents. 
EXPO is a register that is incremented or decremented if the preliminary result of the floating addition ins not normalized. 
MANT is a register that holds the preliminary result of the fraction part of the floating addition. SMALL_ALU, is an ALU 
that obtains the difference of REG_A and REG_B's exponents. 

TEMP is a register that holds the REG_B's fraction that is shifted to align REG_B's exponent with the REG_A's exponent. 
The digital circuit has an external signal "go" such that, after the CONTROL module leaves the reset state, 
the value of the "go" signal is verified. While go = "1", the CONTROL module remains in a state" waiting for go = "0". 

When "go" goes to "0", the values in the REG_A and REG_B registers will be loaded in a serial fashion by 64 clock pulses,
and then the floating-point addition opertation starts. At the end of the floating-point addition operation, 
the circuit must produce the signal done = "1". If the result of the addition generates an overflow or underflow, over = "1" 
or under = "1" must be generated, respectively, and "0" for these signals in case of a normal result. On the other 
hand, there will be an external "reset" signal, such that when applied (value "1"), the entire circuit resets asynchronously.

Initially, the design was implemented and tested on a Cyclone V SoC FPGA from Altera (now Intel), using Electronic Design 
Automation (EDA) Quartus Prime Lite Edition 25.1, first for VHDL hardware description language, and later converted to 
Verilog hardware description language. The initial version of Verilog hardware description for Quartus was adapted to work 
with Librelane. Initial simulations were performed with Vector Waveform File (VWF) from Quartus, and some testbenches were 
also performed using EDA Playground (https://www.edaplayground.com)
