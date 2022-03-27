module SudokuPlantDesign

    # module loading
    using BlockArrays
    using ProgressMeter
    using PyPlot
    using Statistics
    using LinearAlgebra



    # include files for check configuration
    include("check_configuration/type_definition.jl")
    include("check_configuration/interface.jl")
    include("check_configuration/utility_functions.jl")

    # include files for monte carlo
    include("monte_carlo/update_type_definition.jl")
    include("monte_carlo/updates/concrete_update_insert_remove.jl")
    include("monte_carlo/updates/concrete_update_new_check_label.jl")
    include("monte_carlo/updates/concrete_update_swap_check_check.jl")
    include("monte_carlo/updates/concrete_update_swap_check_genotype.jl")
    include("monte_carlo/cost_functions.jl")
    include("monte_carlo/monte_carlo.jl")

end
