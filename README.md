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
## Background

This package is inspired by a recent research paper of Vo-Tanh and Piepho 2020 (https://www.sciencedirect.com/science/article/abs/pii/S0167947320300797) with the idea of implementing augmented quasi-sudoku designs in plant field trials to optimize the check distribution in e.g. augmented designs in plant breeding trials and therefore avoid clustering of checks.

Instead of finding the mathematical optimum, the package SudokuPlantDesign allows to construct good, but not necessarily best possible configurations which serve as good estimates to the optimum solution. This is achieved by utilizing simulated annealing and Monte Carlo techniques to optimize user-defined cost functions.

In practical use, the package allows to find good designs for flexible dimensions of field trials. For example, custom sizes of blocks, custom amounts of genotypes as well as L-shaped trials are possible to design. Missing plots can be pre-defined and will be ignored in the allocation of checks and entries. Efficient runtime is achieved by only partial calculation of the cost function in each update, as a lot of buffer variables keep track of other static parts. In practice, this means it takes only a few seconds till the design is outputted.
