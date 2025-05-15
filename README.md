# Estructura de Computadores - Práctica 1

Este repositorio contiene las implementaciones en ensamblador RISC-V para la Práctica 1 de la asignatura **Estructura de Computadores** de la Universidad Carlos III de Madrid.

## Estructura del repositorio

* **ex\_1.s**: Código en ensamblador que implementa:

  * Cálculo de funciones usando series de Taylor:

    * `sin(x)`
    * `cos(x)`
    * `tg(x)`
  * Cálculo de la constante `e`.
* **ex\_2.s**: Código en ensamblador que aplica `sin(x)` a cada elemento de una matriz 3×3:

  * Lee la matriz `matrix_a` y escribe los resultados en `matrix_b`.
* **README.md**: Documentación del proyecto.

## Requisitos

* Simulador y ensamblador RISC-V (por ejemplo, [RARS](https://github.com/TheThirdOne/rars) o `riscv64-unknown-elf-gcc` + `qemu`).
* Sistema operativo Linux (o entorno compatible).
* Java (si usas RARS).

## Compilación y ejecución

### Con RARS (GUI o CLI)

```bash
# Ensamblar y ejecutar ex_1.s
java -jar rars.jar nc ex_1.s

# Ensamblar y ejecutar ex_2.s
java -jar rars.jar nc ex_2.s
```

### Con toolchain GNU y QEMU

```bash
# Ejemplo para ex_1.s
riscv64-unknown-elf-gcc -march=rv32imf ex_1.s -o ex1
qemu-riscv32 ex1

# Ejemplo para ex_2.s
riscv64-unknown-elf-gcc -march=rv32imf ex_2.s -o ex2
qemu-riscv32 ex2
```

## Uso

1. Ejecuta el binario o ensambla con RARS.
2. Introduce los datos por consola cuando se solicite.
3. Observa la salida en la terminal.

## Ejemplos de salida

* **ex\_1.s**:

  ```
  Introduce tu número en radianes:
  1.5708
  Sine: 1.0000
  Cosine: 0.0000
  Tangent: +inf
  e: 2.7183
  ```
* **ex\_2.s**:
  Tras ejecutar, la matriz `matrix_b` contiene los valores de `sin(matrix_a[i][j])`.
