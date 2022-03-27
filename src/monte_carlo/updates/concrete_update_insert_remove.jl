###################
# INSERT CHECK (into previously plot =0 field)
###################

mutable struct UpdateInsertCheck <: AbstractUpdate

    # position
    i :: Int64
    j :: Int64

    # check
    check :: Int64


    # constructor
    function UpdateInsertCheck()
        return new(-1,-1,-1)
    end

end

function apply_update!(conf :: C, updt :: UpdateInsertCheck) where {C <: CheckConfiguration}
    # set the check in the configuration
    set_check!(conf, updt.i,updt.j, updt.check)
end
function reverse_update!(conf :: C, updt :: UpdateInsertCheck) where {C <: CheckConfiguration}
    # set the previous thing in the configuration
    set_genotype!(conf, updt.i,updt.j)
end

function generate!(updt :: UpdateInsertCheck, conf :: C) where {C <: CheckConfiguration}
    # find suitable position
    updt.i = rand(1:sizex(conf))
    updt.j = rand(1:sizey(conf))
    while !is_genotype(conf, updt.i,updt.j)
        updt.i = rand(1:sizex(conf))
        updt.j = rand(1:sizey(conf))
    end
    # find random check and build new update
    updt.check = rand(1:conf.N)
    # return nothing
    return nothing
end




###################
# REMOVE CHECK (and turn into plot =0 field)
###################

mutable struct UpdateRemoveCheck <: AbstractUpdate

    # position
    i :: Int64
    j :: Int64

    # check
    check :: Int64


    # constructor
    function UpdateRemoveCheck()
        return new(-1,-1,-1)
    end

end

function apply_update!(conf :: C, updt :: UpdateRemoveCheck) where {C <: CheckConfiguration}
    # set the previous thing in the configuration
    set_genotype!(conf, updt.i,updt.j)
end
function reverse_update!(conf :: C, updt :: UpdateRemoveCheck) where {C <: CheckConfiguration}
    # set the check in the configuration
    set_check!(conf, updt.i,updt.j, updt.check)
end

function generate!(updt :: UpdateRemoveCheck, conf :: C) where {C <: CheckConfiguration}
    # find suitable position
    updt.i = rand(1:sizex(conf))
    updt.j = rand(1:sizey(conf))
    while !is_check(conf, updt.i,updt.j)
        updt.i = rand(1:sizex(conf))
        updt.j = rand(1:sizey(conf))
    end
    # find random check and build new update
    updt.check = get_check(conf, updt.i,updt.j)
    # return nothing
    return nothing
end
