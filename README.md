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

This package is inspired by a recent research paper of Vo-Tanh and Piepho 2020 (https://www.sciencedirect.com/science/article/abs/pii/S0167947320300797) with the idea of implementing augmented quasi-sudoku designs in plant field trials with the goal of optimizing the check distribution in e.g. augmented designs in plant breeding trials and therefore avoid clustering of checks. The package SudokuPlantDesign does not work with columns, rows and row/column groups as suggested in the paper, but instead maximizes the distance of same and different checks to each other, similar as repulling particles. This allows
