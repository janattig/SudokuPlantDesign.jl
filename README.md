# SudokuPlantDesign.jl

Julia package for Sudoku-like plant design



## Installation

You can install the package via the package mode in Julia (Pkg). However, since the package is not listed in the Julia package repositories, install it with its dependencies via
```julia-REPL
add BlockArrays DataFrames LinearAlgebra ProgressMeter PyPlot Random Statistics "https://github.com/janattig/SudokuPlantDesign.jl"
```

You can use the code after having it installed by importing the module as
```julia
using SudokuPlantDesign
```



## Usage / Examples

For diving right in, check out the example about the augmented design, which can be found [here](examples/sudoku_basic.ipynb).

In total, you can find the following example files:
- basic usage example for the optimization algorithm [[notebook]](examples/sudoku_basic.ipynb)
- example of augmented Sudoku design including how to make a field plan [[notebook]](examples/sudoku_augmented.ipynb)
- RCBD example [[notebook]](examples/sudoku_RCBD.ipynb)



## Background

This package is inspired by a recent research paper of Vo-Tanh and Piepho 2020 (https://www.sciencedirect.com/science/article/abs/pii/S0167947320300797) with the idea of implementing augmented quasi-Sudoku designs in plant field trials to optimize the check distribution in e.g. augmented designs in plant breeding trials and therefore avoid clustering of checks.

Instead of finding the mathematical optimum, the package SudokuPlantDesign.jl allows for constructing good, but not necessarily best, configurations which serve as sufficiently good estimates to the optimal solution. This is achieved by optimizing check configurations in a combination of simulated annealing and classical Monte Carlo techniques to minimize user-defined cost functions.

In practical use, the package allows to find good designs for flexible dimensions of field trials. For example, custom sizes of blocks, custom amounts of entries as well as L-shaped trials are possible to design. Missing plots can be defined before optimization and will be ignored in the allocation of checks and entries. Efficient code-runtime is achieved by only partial calculation of the cost functions in each update, as a lot of buffer variables keep track of other static parts. In practice, this means it takes only a few seconds until a design is optimized.
