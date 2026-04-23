 [English](README.en.md) || [Español](README.md) || [中文](README.zh.md)
 
 # Computer Structure - Lab 1
 
 This repository contains RISC-V assembly implementations for Lab 1 of the **Computer Structure** course at Universidad Carlos III de Madrid.
 
 ## Repository structure
 
 * **ex_1.s**: Assembly code that implements:
 
   * Function computation using Taylor series:
 
     * `sin(x)`
     * `cos(x)`
     * `tg(x)`
   * Computation of the constant `e`.
 * **ex_2.s**: Assembly code that applies `sin(x)` to each element of a 3×3 matrix:
 
   * Reads the matrix `matrix_a` and writes the results to `matrix_b`.
 * **README.md**: Project documentation (Spanish).
 
 ## Requirements
 
 * RISC-V simulator and assembler (for example, [RARS](https://github.com/TheThirdOne/rars) or `riscv64-unknown-elf-gcc` + `qemu`).
 * Linux operating system (or compatible environment).
 * Java (if you use RARS).
 
 ## Build and run
 
 ### With RARS (GUI or CLI)
 
 ```bash
 # Assemble and run ex_1.s
 java -jar rars.jar nc ex_1.s
 
 # Assemble and run ex_2.s
 java -jar rars.jar nc ex_2.s
 ```
 
 ### With GNU toolchain and QEMU
 
 ```bash
 # Example for ex_1.s
 riscv64-unknown-elf-gcc -march=rv32imf ex_1.s -o ex1
 qemu-riscv32 ex1
 
 # Example for ex_2.s
 riscv64-unknown-elf-gcc -march=rv32imf ex_2.s -o ex2
 qemu-riscv32 ex2
 ```
 
 ## Usage
 
 1. Run the binary or assemble with RARS.
 2. Enter the input in the console when prompted.
 3. Check the output in the terminal.
 
 ## Output examples
 
 * **ex_1.s**:
 
   ```
   Enter your number in radians:
   1.5708
   Sine: 1.0000
   Cosine: 0.0000
   Tangent: +inf
   e: 2.7183
   ```
 * **ex_2.s**:
   After running, the `matrix_b` matrix contains the values of `sin(matrix_a[i][j])`.
