# Type Definition
mutable struct LabeledCheckConfiguration{C <: CheckConfiguration}

    # check configuration
    configuration :: C

    # indices
    indices :: BlockArray{Int64}

    # labels
    labels :: BlockArray{Vector{String}}

end
export LabeledCheckConfiguration







# generate configuration
function LabeledCheckConfiguration(conf :: C) where {C <: CheckConfiguration}

    # obtain block sizes from configuration
    blocksizes_x = [blocksizex(conf,i,1) for i in 1:blocksx(conf)]
    blocksizes_y = [blocksizey(conf,1,j) for j in 1:blocksy(conf)]

    # build empty arrays for indices and labels
    indices = BlockArray{Int64}(undef, blocksizes_x, blocksizes_y)
    labels  = BlockArray{Vector{String}}(undef, blocksizes_x, blocksizes_y)

    # set all indices to "-1" which indicates an unused index
    indices .= -1

    # build object
    labeled_conf = LabeledCheckConfiguration{C}(conf, indices, labels)

    # set empty lists for the labels
    for i in eachindex(labeled_conf.labels)
        labeled_conf.labels[i] = []
    end

    # return object
    return labeled_conf
end
