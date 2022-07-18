############################
#
# Coordinate conversion
#
############################

# global (i,j) --> block (bi,bj, i,j)
function to_block_index(lconf :: LC, x::Int64,y::Int64) :: Tuple{Int64, Int64, Int64, Int64} where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return to_block_index(lconf.configuration, x,y)
end

function get_block_index_x(lconf :: LC, x::Int64) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return get_block_index_x(lconf.configuration, x)
end
function get_block_index_y(lconf :: LC, y::Int64) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return get_block_index_y(lconf.configuration, y)
end

# block (bi,bj, i,j) --> global (i,j)
function to_global_index(lconf :: LC, bi::Int64,bj::Int64, i::Int64,j::Int64) :: Tuple{Int64, Int64} where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return to_global_index(lconf.configuration, bi,bj, i,j)
end

function get_index_x(lconf :: LC, bi::Int64,i::Int64) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return get_index_x(lconf.configuration, bi,i)
end
function get_index_y(lconf :: LC, bj::Int64,j::Int64) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return get_index_y(lconf.configuration, bj,j)
end






############################
#
# (X,Y) Coordinates
#
############################


############
# SIZE Functions
############

function sizex(lconf :: LC) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return sizex(lconf.configuration)
end
export sizex
function sizey(lconf :: LC) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return sizey(lconf.configuration)
end
export sizey






############################
#
# (Bx,By, i,j) Coordinates (Blocks)
#
############################


############
# SIZE Functions
############

function blocksx(lconf :: LC) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return blocksx(lconf.configuration)
end
function blocksy(lconf :: LC) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return blocksy(lconf.configuration)
end

function numblocks(lconf :: LC) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return numblocks(lconf.configuration)
end

function blocksizex(lconf :: LC, i::Int64, j::Int64) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return blocksizex(lconf.configuration, i,j)
end
function blocksizey(lconf ::LC, i::Int64, j::Int64) :: Int64 where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}
    return blocksizey(lconf.configuration, i,j)
end
