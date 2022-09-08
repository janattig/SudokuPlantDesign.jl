#########################
# COST FUNCTION BLOCKS
# CheckConfiguration, Parameters -> Float64
#########################




#####################
# 1. TOTAL NUMBERS
#####################


# Total number of checks (not specifying which ones)
function K_num_checks_total(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    return (conf.num_checks_total - num_checks)^2
end
export K_num_checks_total
function K_num_checks_per_type(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for n in 1:conf.N
        kosten += (conf.num_checks[n] - num_checks)^2
    end
    return kosten/conf.N
end
export K_num_checks_per_type
function K_num_checks_per_type(conf :: C, num_checks :: Vector{<:Integer}) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for n in 1:conf.N
        # add costs
        kosten += (conf.num_checks[n] - num_checks[n])^2
    end
    return kosten/conf.N
end
export K_num_checks_per_type
function K_num_checks_equal_per_type(conf :: C) :: Float64 where {C <: CheckConfiguration}
    return var(conf.num_checks)
end
export K_num_checks_equal_per_type


# Total number of entries
function K_num_entries_total(conf :: C, num_entries :: Integer) :: Float64 where {C <: CheckConfiguration}
    return ((conf.num_plots_total-conf.num_checks_total) - num_entries)^2
end
export K_num_entries_total





#####################
# 2. PER BLOCK
#####################

# minimal number of checks per block
function K_min_checks_per_type_per_block(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:blocksx(conf)
        for j in 1:blocksy(conf)
            for n in 1:conf.N
                kosten += (conf.num_checks_block[i,j][n] > num_checks)*(conf.num_checks_block[i,j][n] - num_checks)^2
            end
        end
    end
    return kosten / (blocksx(conf)*blocksy(conf)*conf.N)
end
export K_min_checks_per_type_per_block

# maximal number of checks per block
function K_max_checks_per_type_per_block(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:blocksx(conf)
        for j in 1:blocksy(conf)
            for n in 1:conf.N
                kosten += (conf.num_checks_block[i,j][n] < num_checks)*(conf.num_checks_block[i,j][n] - num_checks)^2
            end
        end
    end
    return kosten / (blocksx(conf)*blocksy(conf)*conf.N)
end
export K_max_checks_per_type_per_block

# exact number of checks per block
function K_checks_per_type_per_block(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:blocksx(conf)
        for j in 1:blocksy(conf)
            for n in 1:conf.N
                kosten += (conf.num_checks_block[i,j][n] - num_checks)^2
            end
        end
    end
    return kosten / (blocksx(conf)*blocksy(conf)*conf.N)
end
export K_checks_per_type_per_block

# exact number of checks per row within a block
function K_checks_per_row_per_block(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:blocksx(conf)
        for j in 1:blocksy(conf)
            for z in 1:blocksizey(conf, i,j)
                kosten += (sum(getblock(conf.configuration,i,j)[:,z] .> 0) - num_checks)^2
            end
        end
    end
    return kosten / (sizey(conf)*conf.N)
end
export K_checks_per_row_per_block


#####################
# 3. PER ROW
#####################

# minimal number of checks per row
function K_min_checks_per_type_per_row(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:sizey(conf)
        for n in 1:conf.N
            kosten += (conf.num_checks_row[i][n] > num_checks)*(conf.num_checks_row[i][n] - num_checks)^2
        end
    end
    return kosten / (sizey(conf)*conf.N)
end
export K_min_checks_per_type_per_row

# maximal number of checks per row
function K_max_checks_per_type_per_row(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:sizey(conf)
        for n in 1:conf.N
            kosten += (conf.num_checks_row[i][n] < num_checks)*(conf.num_checks_row[i][n] - num_checks)^2
        end
    end
    return kosten / (sizey(conf)*conf.N)
end
export K_max_checks_per_type_per_row

# exact number of checks per row
function K_checks_per_type_per_row(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:sizey(conf)
        for n in 1:conf.N
            kosten += (conf.num_checks_row[i][n] - num_checks)^2
        end
    end
    return kosten / (sizey(conf)*conf.N)
end
export K_checks_per_type_per_row






#####################
# 4. PER COLUMN
#####################

# minimal number of checks per column
function K_min_checks_per_type_per_column(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:sizex(conf)
        for n in 1:conf.N
            kosten += (conf.num_checks_col[i][n] > num_checks)*(conf.num_checks_col[i][n] - num_checks)^2
        end
    end
    return kosten / (sizex(conf)*conf.N)
end
export K_min_checks_per_type_per_column

# maximal number of checks per column
function K_max_checks_per_type_per_column(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:sizex(conf)
        for n in 1:conf.N
            kosten += (conf.num_checks_col[i][n] < num_checks)*(conf.num_checks_col[i][n] - num_checks)^2
        end
    end
    return kosten / (sizex(conf)*conf.N)
end
export K_max_checks_per_type_per_column

# exact number of checks per column
function K_checks_per_type_per_column(conf :: C, num_checks :: Integer) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:sizex(conf)
        for n in 1:conf.N
            kosten += (conf.num_checks_col[i][n] - num_checks)^2
        end
    end
    return kosten / (sizex(conf)*conf.N)
end
export K_checks_per_type_per_column




#####################
# 5. NEIGHBORS
#####################

function K_neighbors_same_check_const(conf :: C, cost :: Number) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:conf.N
        kosten += sum(conf.neighbor_pairs[i,i])
    end
    return kosten*cost
end
export K_neighbors_same_check_const
function K_neighbors_same_check_dmax_const(conf :: C, dmax::Int, cost :: Number) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:conf.N
        kosten += sum(conf.neighbor_pairs[i,i][1:min(conf.dmax, dmax)])
    end
    return kosten*cost
end
export K_neighbors_same_check_dmax_const
function K_neighbors_same_check_functional(conf :: C, f :: Function) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:conf.N
        for d in 1:conf.dmax
            kosten += conf.neighbor_pairs[i,i][d] * f(d)
        end
    end
    return kosten
end
export K_neighbors_same_check_functional

function K_neighbors_different_check_const(conf :: C, cost :: Number) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:conf.N
        for j in i+1:conf.N
            kosten += sum(conf.neighbor_pairs[i,j])
        end
    end
    return kosten*cost
end
export K_neighbors_different_check_const
function K_neighbors_different_check_dmax_const(conf :: C, dmax::Int, cost :: Number) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:conf.N
        for j in i+1:conf.N
            kosten += sum(conf.neighbor_pairs[i,j][1:min(conf.dmax, dmax)])
        end
    end
    return kosten*cost
end
export K_neighbors_different_check_dmax_const
function K_neighbors_different_check_functional(conf :: C, f :: Function) :: Float64 where {C <: CheckConfiguration}
    kosten = 0
    for i in 1:conf.N
        for j in i+1:conf.N
            for d in 1:conf.dmax
                kosten += conf.neighbor_pairs[i,j][d] * f(d)
            end
        end
    end
    return kosten
end
export K_neighbors_different_check_functional
