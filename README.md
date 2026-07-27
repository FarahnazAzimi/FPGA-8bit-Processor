# FPGA 8-bit Processor

## Overview

This project presents the design and simulation of an 8-bit processor implemented in VHDL for a Spartan-6 FPGA.

The processor was developed as part of a digital systems and FPGA course to demonstrate the implementation of a simple CPU architecture using hardware description language.

The design includes all essential processor components such as the Arithmetic Logic Unit (ALU), Register File, Control Unit, Program Counter, Program Memory, Data Memory and Instruction Decoder.

The processor was designed using Xilinx ISE and verified through ISIM simulation.

## Features

- 8-bit processor architecture
- Modular VHDL implementation
- Arithmetic Logic Unit (ALU)
- Register File
- Program Counter
- Control Unit
- Instruction Decoder
- Program Memory
- Data Memory
- ISIM simulation

- ## Technologies

- VHDL
- FPGA
- Spartan-6
- Xilinx ISE
- ISIM

## Processor Architecture

The processor consists of the following modules:

- ALU
- Register File
- Control Unit
- Program Counter
- Program Memory
- Data Memory
- Instruction Decoder

All modules communicate through an internal 8-bit data bus.

            +----------------+
            | Program Memory |
            +----------------+
                    |
                    |
           +-----------------+
           | Instruction Reg |
           +-----------------+
                    |
          +-------------------+
          |   Control Unit    |
          +-------------------+
          |                   |
    +-----------+      +-------------+
    | Register  |<---->|     ALU     |
    |   File    |      +-------------+
    +-----------+
          |
     Data Memory
