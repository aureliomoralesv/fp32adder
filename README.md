[![Librelane Digital Flow (UNIC-CASS)](https://github.com/unic-cass/unic-cass-wrapper/actions/workflows/digital-flow.yaml/badge.svg?branch=dev&event=push)](https://github.com/unic-cass/unic-cass-wrapper/actions/workflows/digital-flow.yaml)

# VLSI implementation of a simple 32-bit floating-point adder based on IEEE 754 using open-source software tools 

> **Project Status:**
>This repository represents an initial report for the project using the UNIC-CASS open-source software tools and the steps performed to the integration of the design to the pad ring for the mock tapeout. The contents of this report will evolve as we go further in the final integration of the design to the final pad ring for the final tape out.

## Team members - Universidad Nacional de Ingeniería, Perú
 - Ariel Amado Frias (student)
 - Alejandro Estefano Zavaleta (student)
 - Manuel Julián Pasión (student)
 - Angel Edmanuel Aguado (student)
 - Aurelio Morales-Villanueva, PhD (mentor)

Table of contents
=================

1. [Description of the project](#description-of-the-project)
2. [Block diagram of the 32-bit floating point adder](#block-diagram-of-the-32-bit-floating-point-adder)
3. [Simulations with Quartus Prime Lite Edition](#simulations-with-quartus-prime-lite-edition)
4. [Integration for mock tapeout](#integration-for-mock-tapeout)
5. [Report of the entire chip flow performed with Librelane](#report-of-the-entire-chip-flow-performed-with-librelane)
6. [Static Timing Analysis after Place and Route](#static-timing-analysis-after-place-and-route)
7. [Report for Manufacturability](#report-for-manufacturability)
8. [View of the design with Openroad before pad ring integration](#view-of-the-design-with-openroad-before-pad-ring-integration)
9. [View of the design with Openroad after pad ring integration](#view-of-the-design-with-openroad-after-pad-ring-integration)


Description of the project 
==========================

The intended design to be integrated on a VLSI chip using IHP SG13G2 PDK is a basic 32-bit floating point adder 
based on IEEE 754. All the modules will be purely digital. According to the block diagram provided, the "reset" 
input asynchronously resets the entire design, then after signal "go" is active (from high to low), two 32-bit 
floating-point numbers are loaded into registers REG_A and REG_B in a serial fashion using one single input "inpab" 
(first REG_A, then REG_B, both from LSB to MSB), using output "shift" for 64 clock pulses, assuming that REG_A is 
greater than REG_B, and the CONTROL block, based on a Finite State Machine (FSM) Moore machine, sends an receives 
several signals to/from others block, and finally the result is generated on REG_C. REG_C is shifted out to the 
left via the output "reg_c" while "done" signal is high for 32 clock pulses.

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

Block diagram of the 32-bit floating point adder
================================================
![architecture](docs/img/fp32adder_serial_block_diagram.png)

Simulations with Quartus Prime Lite Edition
===========================================
![architecture](docs/img/fp32adder_serial_simulation-1of2.png)
Behavioral simulation on Cyclone V SoC FPGA of 32-bit floating point adder using Quartus Prime Lite Edition 25.1 (1 of 2)

![architecture](docs/img/fp32adder_serial_simulation-2of2.png)
Behavioral simulation on Cyclone V SoC FPGA of 32-bit floating point adder using Quartus Prime Lite Edition 25.1 (2 of 2)

Integration for mock tapeout
============================

This part of the report was already included as part of the first milestone on 27/01/2026 in the README located at [docs](https://github.com/aureliomoralesv/fp32adder/tree/b76bced529d6ac0d960cf93f927288e4b94851ef/docs) folder. The initial steps for the integration of the digital design project to the pad ring is based on the UNIC-CASS Wrapper as an open-source chip integration template designed to standardize and simplify the integration of UNIC-CASS circuit designs for fabrication using the IHP open-source PDK. Please, read that report, which include all the steps and customization performed for the integration of the design to the initial pad ring for the mock tapeout.

Also, inside the [docs](https://github.com/aureliomoralesv/fp32adder/tree/b76bced529d6ac0d960cf93f927288e4b94851ef/docs) folder, there is the [testbenches](https://github.com/aureliomoralesv/fp32adder/tree/b76bced529d6ac0d960cf93f927288e4b94851ef/docs/testbenches) folder, which includes several testbenches for the design in order to verify the behavioral results using different operands and using the Questa simulation tool included as part of the Quartus Prime Lite Edition 25.1. Also, in the testbenches folder, the Questa-step-by-step.pdf shows the steps to be performed for the functional simulation of the original design which was useful to detect possible bugs in the design.

Report of the entire chip flow performed with Librelane
=======================================================

The following image shows all the folders generated when the chip flow was performed using the Librelane. The entire flow performs the logic synthesis and optimizations, mapping, place and route, timing constraints analysis using the Synopsys Design Constraint (*sdc) file, static timing analysis after place and route, design rule checking (DRC), and layout versus schematic (LVS) check for manufacturing and pad ring integration, where the error.log file shows no errors, while the warnings are related with no parasitics extraction found at corner of nom_fast_1p32V_m40C and nom_slow_1p08V_125C models.

![architecture](docs/img/fp32adder_serial_entire_chip_flow.png)
Image that captures the entire chip flow performed with Librelane 

Static Timing Analysis after Place and Route
============================================
![architecture](docs/img/fp32adder_serial_openroad-stapostpnr.png)
Static timing analysis with Openroad after Place & Route of the design

Report for Manufacturability
============================
![architecture](docs/img/fp32adder_serial_misc-reportmanufacturability.png)
Report for manufacturability (Antenna, DRC and LVS) of the design

View of the design with Openroad before pad ring integration
============================================================
![architecture](docs/img/fp32adder_serial_no_padring-2026-01-24.png)
View of the design without pad ring integration using OpenRoad

View of the design with Openroad after pad ring integration
===========================================================
![architecture](docs/img/fp32adder_serial_with_padring_zoom-2026-01-26.png)
Zoom view of the placed design and integrated with the pad ring using OpenRoad
