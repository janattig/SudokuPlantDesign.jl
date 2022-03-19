# Type Definition
# Check Configuration -- how checks are distributed on the available space
mutable struct CheckConfiguration{B <: BlockArray}

    # configuration itself
    configuration :: B

    # anzahl verschiedener checks
    N :: Int64


    # TOTAL
    num_checks       :: Vector{Int64}
    num_checks_total :: Int64
    num_plots_total  :: Int64
    length_total     :: Int64


    # BLOCKS

    # anzahl checks im block (aufgeteilt nach checks und insgesamt)
    num_checks_block       :: Matrix{Vector{Int64}}
    num_checks_block_total :: Matrix{Int64}

    # anzahl an plots im block (non-empty felder)
    num_plots_block :: Matrix{Int64}
    # laenge des blocks (alle felder)
    length_block    :: Matrix{Int64}



    # ROWS

    # anzahl checks im block (aufgeteilt nach checks und insgesamt)
    num_checks_row       :: Vector{Vector{Int64}}
    num_checks_row_total :: Vector{Int64}

    # anzahl an plots im block (non-empty felder)
    num_plots_row :: Vector{Int64}
    # laenge des blocks (alle felder)
    length_row    :: Vector{Int64}


    # COLUMNS

    # anzahl checks im block (aufgeteilt nach checks und insgesamt)
    num_checks_col       :: Vector{Vector{Int64}}
    num_checks_col_total :: Vector{Int64}

    # anzahl an plots im block (non-empty felder)
    num_plots_col :: Vector{Int64}
    # laenge des blocks (alle felder)
    length_col    :: Vector{Int64}


    # PAIRS OF NEIGHBORING CHECKS
    # element [c1,c2] contains list number of pairs c1-c2 at distances 1..dmax
    dmax :: Int64
    neighbor_pairs :: Matrix{Vector{Int64}}

end








# generate configuration
function get_configuration(blocksizes_x::Vector{<:Int64}, blocksizes_y::Vector{<:Int64}, N::Int64, dmax::Int64=5)

    # build new check configuration
    conf = BlockArray{Int64}(undef, blocksizes_x, blocksizes_y)
    # set all elements to 0 (= plant is there)
    conf .= 0


    # TOTAL
    num_checks       = zeros(Int64, N)
    num_checks_total = 0
    num_plots_total  = length(conf)
    length_total     = length(conf)



    # BLOCK

    # anzahl checks im block (aufgeteilt nach checks und insgesamt)
    num_checks_block       = Matrix{Vector{Int64}}(undef, length(blocksizes_x), length(blocksizes_y))
    for i in eachindex(num_checks_block)
        num_checks_block[i] = zeros(Int64, N)
    end
    num_checks_block_total = zeros(Int64, length(blocksizes_x), length(blocksizes_y))
    # laenge des blocks (alle felder)
    length_block    = zeros(Int64, length(blocksizes_x), length(blocksizes_y))
    for i in 1:size(blocks(conf))[1]
        for j in 1:size(blocks(conf))[2]
            length_block[i,j] = length(getblock(conf, i,j))
        end
    end
    # anzahl an plots im block (non-empty felder)
    num_plots_block = copy(length_block)


    # ROW

    # anzahl checks in rows (aufgeteilt nach checks und insgesamt)
    num_checks_row       = Vector{Vector{Int64}}(undef, size(conf)[2])
    for i in eachindex(num_checks_row)
        num_checks_row[i] = zeros(Int64, N)
    end
    num_checks_row_total = zeros(Int64, size(conf)[2])
    # laenge der zeile (alle felder)
    length_row    = zeros(Int64, size(conf)[2])
    for i in 1:length(length_row)
        length_row[i] = size(conf)[1]
    end
    # anzahl an plots im row (non-empty felder)
    num_plots_row = copy(length_row)


    # COLUMN

    # anzahl checks in columns (aufgeteilt nach checks und insgesamt)
    num_checks_col       = Vector{Vector{Int64}}(undef, size(conf)[1])
    for i in eachindex(num_checks_col)
        num_checks_col[i] = zeros(Int64, N)
    end
    num_checks_col_total = zeros(Int64, size(conf)[1])
    # laenge der spalte (alle felder)
    length_col    = zeros(Int64, size(conf)[1])
    for i in 1:length(length_col)
        length_col[i] = size(conf)[2]
    end
    # anzahl an plots im column (non-empty felder)
    num_plots_col = copy(length_col)
    
    
    # NEIGHBORS
    nb = Matrix{Vector{Int64}}(undef, N,N)
    for i in 1:N
        for j in 1:N
            nb[i,j] = zeros(Int64, dmax)
        end
    end
    

    # build object
    C = CheckConfiguration(
        conf, N,
        num_checks,
        num_checks_total,
        num_plots_total,
        length_total,
        num_checks_block,
        num_checks_block_total,
        num_plots_block,
        length_block,
        num_checks_row,
        num_checks_row_total,
        num_plots_row,
        length_row,
        num_checks_col,
        num_checks_col_total,
        num_plots_col,
        length_col,
        dmax,
        nb
    )

    # return object
    return C
end
