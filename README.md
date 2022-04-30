# SudokuPlantDesign.jl

Julia package for Sudoku-like plant design



## Installation

You can install the package via the package mode in Julia (Pkg). However, since the package
is not listed in the Julia package repositories install as
```julia-REPL
add "https://github.com/janattig/SudokuPlantDesign.jl"
```

## Usage

You can use the code after having it installed by importing the module as
```julia
using SudokuPlantDesign
```
Initial augmented design - random distribution of checks per block
![Check Distribution](https://github.com/janattig/SudokuPlantDesign.jl/blob/main/figures/initial_random_check_distribution.png)

Sudoku-augmented design - optimized checks distribution

Sudoku-RCBD design - optimized checks distribution

## Background

This package is inspired by a recent research paper of Vo-Tanh and Piepho 2020 (https://www.sciencedirect.com/science/article/abs/pii/S0167947320300797) with the idea of implementing augmented quasi-sudoku designs in plant field trials to optimize the check distribution in e.g. augmented designs in plant breeding trials and therefore avoid clustering of checks.

Instead of finding the mathematical optimum, the package SudokuPlantDesign.jl allows for constructing good, but not necessarily best, configurations which serve as sufficiently good estimates to the optimal solution. This is achieved by optimizing check configurations in a combination of simulated annealing and classical Monte Carlo techniques to minimize user-defined cost functions.

In practical use, the package allows to find good designs for flexible dimensions of field trials. For example, custom sizes of blocks, custom amounts of genotypes as well as L-shaped trials are possible to design. Missing plots can be defined before optimization and will be ignored in the allocation of checks and entries. Efficient code-runtime is achieved by only partial calculation of the cost functions in each update, as a lot of buffer variables keep track of other static parts. In practice, this means it takes only a few seconds until a design is optimized.
