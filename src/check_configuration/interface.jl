############################
#
# Coordinate conversion
#
############################

# global (i,j) --> block (bi,bj, i,j)
function to_block_index(conf :: C, x::Int64,y::Int64) :: Tuple{Int64, Int64, Int64, Int64} where {C <: CheckConfiguration}
    a1 = findblockindex(axes(conf.configuration)[1], x)
    a2 = findblockindex(axes(conf.configuration)[2], y)
    return a1.I[1], a2.I[1], a1.α[1],a2.α[1]
end

function get_block_index_x(conf :: C, x::Int64) :: Int64 where {C <: CheckConfiguration}
    return findblockindex(axes(conf.configuration)[1], x).I[1]
end
function get_block_index_y(conf :: C, y::Int64) :: Int64 where {C <: CheckConfiguration}
    return findblockindex(axes(conf.configuration)[2], y).I[1]
end

# block (bi,bj, i,j) --> global (i,j)
function to_global_index(conf :: C, bi::Int64,bj::Int64, i::Int64,j::Int64) :: Tuple{Int64, Int64} where {C <: CheckConfiguration}
    x = i
    y = j
    for b in 1:bi-1
        x += blocksizex(conf,b,bj)
    end
    for b in 1:bj-1
        y += blocksizey(conf,bi,b)
    end
    return x,y
end

function get_index_x(conf :: C, bi::Int64,i::Int64) :: Int64 where {C <: CheckConfiguration}
    x = i
    for b in 1:bi-1
        x += blocksizex(conf,b,1)
    end
    return x
end
function get_index_y(conf :: C, bj::Int64,j::Int64) :: Int64 where {C <: CheckConfiguration}
    y = j
    for b in 1:bj-1
        y += blocksizey(conf,1,b)
    end
    return y
end








############################
#
# (X,Y) Coordinates
#
############################


############
# SIZE Functions
############

function sizex(conf :: C) where {C <: CheckConfiguration}
    return size(conf.configuration)[1]
end
export sizex
function sizey(conf :: C) where {C <: CheckConfiguration}
    return size(conf.configuration)[2]
end
export sizey




############
# GETTER
############

function is_empty(conf :: C, i::Int64, j::Int64) :: Bool where {C <: CheckConfiguration}
    # ask in the configuration
    return conf.configuration[i,j] == -1
end

function is_genotype(conf :: C, i::Int64, j::Int64) :: Bool where {C <: CheckConfiguration}
    # ask in the configuration
    return conf.configuration[i,j] == 0
end

function is_check(conf :: C, i::Int64, j::Int64) :: Bool where {C <: CheckConfiguration}
    # ask in the configuration
    return conf.configuration[i,j] > 0
end



function get_check(conf :: C, i::Int64, j::Int64) :: Int64 where {C <: CheckConfiguration}
    # ask in the configuration
    return conf.configuration[i,j]
end







############
# SETTER
############

function set_empty!(conf :: C, i::Int64, j::Int64) where {BC, BA<:BlockArray, C <: CheckConfiguration{BC,BA}}
    @error "not implemented interface function \"set_empty!(C,i,j)\" for boundary conditions "*string(BC)*" yet"
end

function set_empty!(conf :: C, i::Int64, j::Int64) where {BA<:BlockArray, C <: CheckConfiguration{OBC,BA}}
    # check which type of field was there before
    if is_empty(conf, i,j)
        # do nothing
    elseif is_genotype(conf, i,j)
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # remove one plot from statistics
        conf.num_plots_block[bi,bj] -= 1
        conf.num_plots_row[j] -= 1
        conf.num_plots_col[i] -= 1
        conf.num_plots_total -= 1
    else
        # block is check
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # remove one plot from statistics
        conf.num_plots_block[bi,bj] -= 1
        conf.num_plots_row[j] -= 1
        conf.num_plots_col[i] -= 1
        conf.num_plots_total -= 1
        # remove one check from statistics
        conf.num_checks_block_total[bi,bj] -= 1
        conf.num_checks_block[bi,bj][get_check(conf, i,j)] -= 1
        conf.num_checks_row_total[j] -= 1
        conf.num_checks_row[j][get_check(conf, i,j)] -= 1
        conf.num_checks_col_total[i] -= 1
        conf.num_checks_col[i][get_check(conf, i,j)] -= 1
        conf.num_checks_total -= 1
        conf.num_checks[get_check(conf,i,j)] -= 1
        # check neighbors
        c1 = get_check(conf, i,j)
        for x in max(i-conf.dmax,1):min(i+conf.dmax,sizex(conf))
        for y in max((j-conf.dmax)+(abs(i-x)),1):min((j+conf.dmax)-(abs(i-x)),sizey(conf))
            if is_check(conf, x,y)
                d = abs(x-i)+abs(y-j)
                if d!=0
                    c2 = get_check(conf,x,y)
                    conf.neighbor_pairs[min(c1,c2),max(c1,c2)][d] -= 1
                end
            end
        end
        end
    end
    # set in the configuration
    conf.configuration[i,j] = -1
end


function set_genotype!(conf :: C, i::Int64, j::Int64) where {BC, BA<:BlockArray, C <: CheckConfiguration{BC,BA}}
    @error "not implemented interface function \"set_genotype!(C,i,j)\" for boundary conditions "*string(BC)*" yet"
end

function set_genotype!(conf :: C, i::Int64, j::Int64) where {BA<:BlockArray, C <: CheckConfiguration{OBC,BA}}
    # check which type of field was there before
    if is_empty(conf, i,j)
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # add one plot to statistics
        conf.num_plots_block[bi,bj] += 1
        conf.num_plots_row[j] += 1
        conf.num_plots_col[i] += 1
        conf.num_plots_total += 1
    elseif is_genotype(conf, i,j)
        # do nothing
    else
        # block is check
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # remove one check from statistics
        conf.num_checks_block_total[bi,bj] -= 1
        conf.num_checks_block[bi,bj][get_check(conf, i,j)] -= 1
        conf.num_checks_row_total[j] -= 1
        conf.num_checks_row[j][get_check(conf, i,j)] -= 1
        conf.num_checks_col_total[i] -= 1
        conf.num_checks_col[i][get_check(conf, i,j)] -= 1
        conf.num_checks_total -= 1
        conf.num_checks[get_check(conf,i,j)] -= 1
        # check neighbors
        c1 = get_check(conf, i,j)
        for x in max(i-conf.dmax,1):min(i+conf.dmax,sizex(conf))
        for y in max((j-conf.dmax)+(abs(i-x)),1):min((j+conf.dmax)-(abs(i-x)),sizey(conf))
            if is_check(conf, x,y)
                d = abs(x-i)+abs(y-j)
                if d!=0
                    c2 = get_check(conf,x,y)
                    conf.neighbor_pairs[min(c1,c2),max(c1,c2)][d] -= 1
                end
            end
        end
        end
    end
    # set in the configuration
    conf.configuration[i,j] = 0
end


function set_check!(conf :: C, i::Int64, j::Int64, c::Int64) where {BC, BA<:BlockArray, C <: CheckConfiguration{BC,BA}}
    @error "not implemented interface function \"set_check!(C,i,j,c)\" for boundary conditions "*string(BC)*" yet"
end

function set_check!(conf :: C, i::Int64, j::Int64, c::Int64) where {BA<:BlockArray, C <: CheckConfiguration{OBC,BA}}
    # check which type of field was there before
    if is_empty(conf, i,j)
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # add one plot to statistics
        conf.num_plots_block[bi,bj] += 1
        conf.num_plots_row[i] += 1
        conf.num_plots_col[j] += 1
        conf.num_plots_total += 1
        # add one check to statistics
        conf.num_checks_block_total[bi,bj] += 1
        conf.num_checks_block[bi,bj][c] += 1
        conf.num_checks_row_total[j] += 1
        conf.num_checks_row[j][c] += 1
        conf.num_checks_col_total[i] += 1
        conf.num_checks_col[i][c] += 1
        conf.num_checks_total += 1
        conf.num_checks[c] += 1
        # check neighbors
        for x in max(i-conf.dmax,1):min(i+conf.dmax,sizex(conf))
        for y in max((j-conf.dmax)+(abs(i-x)),1):min((j+conf.dmax)-(abs(i-x)),sizey(conf))
            if is_check(conf, x,y)
                d = abs(x-i)+abs(y-j)
                if d!=0
                    c2 = get_check(conf,x,y)
                    conf.neighbor_pairs[min(c,c2),max(c,c2)][d] += 1
                end
            end
        end
        end
    elseif is_genotype(conf, i,j)
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # add one check to statistics
        conf.num_checks_block_total[bi,bj] += 1
        conf.num_checks_block[bi,bj][c] += 1
        conf.num_checks_row_total[j] += 1
        conf.num_checks_row[j][c] += 1
        conf.num_checks_col_total[i] += 1
        conf.num_checks_col[i][c] += 1
        conf.num_checks_total += 1
        conf.num_checks[c] += 1
        # check neighbors
        for x in max(i-conf.dmax,1):min(i+conf.dmax,sizex(conf))
        for y in max((j-conf.dmax)+(abs(i-x)),1):min((j+conf.dmax)-(abs(i-x)),sizey(conf))
            if is_check(conf, x,y)
                d = abs(x-i)+abs(y-j)
                if d!=0
                    c2 = get_check(conf,x,y)
                    conf.neighbor_pairs[min(c,c2),max(c,c2)][d] += 1
                end
            end
        end
        end
    else
        # block is check
        # find out block indizes
        bi = get_block_index_x(conf, i)
        bj = get_block_index_y(conf, j)
        # remove one check from statistics and add new one
        conf.num_checks_block[bi,bj][c] += 1
        conf.num_checks_block[bi,bj][get_check(conf, i,j)] -= 1
        conf.num_checks_row[j][c] += 1
        conf.num_checks_row[j][get_check(conf, i,j)] -= 1
        conf.num_checks_col[i][c] += 1
        conf.num_checks_col[i][get_check(conf, i,j)] -= 1
        conf.num_checks[c] += 1
        conf.num_checks[get_check(conf, i,j)] -= 1
        # maybe check neighbors
        if c != get_check(conf, i,j)
            c1 = get_check(conf, i,j)
            for x in max(i-conf.dmax,1):min(i+conf.dmax,sizex(conf))
            for y in max((j-conf.dmax)+(abs(i-x)),1):min((j+conf.dmax)-(abs(i-x)),sizey(conf))
                if is_check(conf, x,y)
                    d = abs(x-i)+abs(y-j)
                    if d!=0
                        c2 = get_check(conf,x,y)
                        conf.neighbor_pairs[min(c,c2),max(c,c2)][d]   += 1
                        conf.neighbor_pairs[min(c1,c2),max(c1,c2)][d] -= 1
                    end
                end
            end
            end
        end
    end
    # set in the configuration
    conf.configuration[i,j] = c
end












############################
#
# (Bx,By, i,j) Coordinates (Blocks)
#
############################


############
# SIZE Functions
############

function blocksx(conf :: C) :: Int64 where {C <: CheckConfiguration}
    return size(blocks(conf.configuration))[1]
end
function blocksy(conf :: C) :: Int64 where {C <: CheckConfiguration}
    return size(blocks(conf.configuration))[2]
end

function numblocks(conf :: C) :: Int64 where {C <: CheckConfiguration}
    return length(blocks(conf.configuration))
end

function blocksizex(conf :: C, i::Int64, j::Int64) :: Int64 where {C <: CheckConfiguration}
    return size(getblock(conf.configuration, i,j))[1]
end
function blocksizey(conf :: C, i::Int64, j::Int64) :: Int64 where {C <: CheckConfiguration}
    return size(getblock(conf.configuration, i,j))[2]
end



############
# GETTER
############

function is_empty(conf :: C, bi::Int64, bj::Int64, i::Int64, j::Int64) :: Bool where {C <: CheckConfiguration}
    # ask in the configuration
    return getblock(conf.configuration, bi,bj)[i,j] == -1
end

function is_genotype(conf :: C, bi::Int64, bj::Int64, i::Int64, j::Int64) :: Bool where {C <: CheckConfiguration}
    # ask in the configuration
    return getblock(conf.configuration, bi,bj)[i,j] == 0
end

function is_check(conf :: C, bi::Int64, bj::Int64, i::Int64, j::Int64) :: Bool where {C <: CheckConfiguration}
    # ask in the configuration
    return getblock(conf.configuration, bi,bj)[i,j] > 0
end



function get_check(conf :: C, bi::Int64, bj::Int64, i::Int64, j::Int64) :: Int64 where {C <: CheckConfiguration}
    # ask in the configuration
    return getblock(conf.configuration, bi,bj)[i,j]
end




############
# SETTER
############

function set_empty!(conf :: C, bi::Int64, bj::Int64, x::Int64, y::Int64) where {C <: CheckConfiguration}
    # find out indices i and j
    i = get_index_x(conf, bi,x)
    j = get_index_y(conf, bj,y)
    # pass to already implemented function
    set_empty!(conf, i,j)
end

function set_genotype!(conf :: C, bi::Int64, bj::Int64, x::Int64, y::Int64) where {C <: CheckConfiguration}
    # find out indices i and j
    i = get_index_x(conf, bi,x)
    j = get_index_y(conf, bj,y)
    # pass to already implemented function
    set_genotype!(conf, i,j)
end

function set_check!(conf :: C, bi::Int64, bj::Int64, x::Int64, y::Int64, c::Int64) where {C <: CheckConfiguration}
    # find out indices i and j
    i = get_index_x(conf, bi,x)
    j = get_index_y(conf, bj,y)
    # pass to already implemented function
    set_check!(conf, i,j, c)
end




# expor the different interface functions
export is_check, is_empty, is_genotype
export get_check
export set_check, set_empty, set_genotype
