 [English](README.en.md) || [Español](README.md) || [中文](README.zh.md)
 
 # 计算机结构 - 实验 1
 
 本仓库包含马德里卡洛斯三世大学（Universidad Carlos III de Madrid）**计算机结构**课程实验 1 的 RISC-V 汇编实现。
 
 ## 仓库结构
 
 * **ex_1.s**：实现以下内容的汇编代码：
 
   * 使用泰勒级数计算函数：
 
     * `sin(x)`
     * `cos(x)`
     * `tg(x)`
   * 计算常数 `e`。
 * **ex_2.s**：将 `sin(x)` 应用于 3×3 矩阵的每个元素的汇编代码：
 
   * 读取矩阵 `matrix_a`，并将结果写入 `matrix_b`。
 * **README.md**：项目文档（西班牙语）。
 
 ## 环境要求
 
 * RISC-V 模拟器与汇编器（例如 [RARS](https://github.com/TheThirdOne/rars) 或 `riscv64-unknown-elf-gcc` + `qemu`）。
 * Linux 操作系统（或兼容环境）。
 * Java（如果使用 RARS）。
 
 ## 编译与运行
 
 ### 使用 RARS（GUI 或 CLI）
 
 ```bash
 # 汇编并运行 ex_1.s
 java -jar rars.jar nc ex_1.s
 
 # 汇编并运行 ex_2.s
 java -jar rars.jar nc ex_2.s
 ```
 
 ### 使用 GNU 工具链与 QEMU
 
 ```bash
 # ex_1.s 示例
 riscv64-unknown-elf-gcc -march=rv32imf ex_1.s -o ex1
 qemu-riscv32 ex1
 
 # ex_2.s 示例
 riscv64-unknown-elf-gcc -march=rv32imf ex_2.s -o ex2
 qemu-riscv32 ex2
 ```
 
 ## 使用方法
 
 1. 运行二进制文件，或使用 RARS 进行汇编运行。
 2. 按提示在控制台输入数据。
 3. 在终端中查看输出结果。
 
 ## 输出示例
 
 * **ex_1.s**：
 
   ```
   请输入你的弧度值：
   1.5708
   Sine: 1.0000
   Cosine: 0.0000
   Tangent: +inf
   e: 2.7183
   ```
 * **ex_2.s**：
   执行后，矩阵 `matrix_b` 将包含 `sin(matrix_a[i][j])` 的结果值。
