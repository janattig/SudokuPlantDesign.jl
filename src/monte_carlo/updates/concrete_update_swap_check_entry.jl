###################
# SWAP A CHECK WITH A ENTRY
###################

mutable struct UpdateSwapCheckEntry <: AbstractUpdate

    # position
    ic :: Int64
    jc :: Int64

    # position
    ig :: Int64
    jg :: Int64

    # check
    check :: Int64



    # constructor
    function UpdateSwapCheckEntry()
        return new(-1,-1,-1,-1,-1)
    end

end
export UpdateSwapCheckEntry






function apply_update!(conf :: C, updt :: UpdateSwapCheckEntry) where {C <: CheckConfiguration}
    # setze check auf ig,jg und entry auf ic,jc
    set_check!(conf,updt.ig,updt.jg,updt.check)
    set_entry!(conf,updt.ic,updt.jc)
end
function reverse_update!(conf :: C, updt :: UpdateSwapCheckEntry) where {C <: CheckConfiguration}
    # setze check auf ic,jc und entry auf ig,jg
    set_check!(conf,updt.ic,updt.jc,updt.check)
    set_entry!(conf,updt.ig,updt.jg)
end

function generate!(updt :: UpdateSwapCheckEntry, conf :: C) where {C <: CheckConfiguration}
    # suche random coordinates und behalte wenn check ist
    updt.ic=rand(1:sizex(conf))
    updt.jc=rand(1:sizey(conf))
    while !is_check(conf,updt.ic,updt.jc)
        updt.ic=rand(1:sizex(conf))
        updt.jc=rand(1:sizey(conf))
    end
    updt.check=get_check(conf,updt.ic,updt.jc)

    # suche random coordinates und behalte wenn ein genotyp ist
    updt.ig=rand(1:sizex(conf))
    updt.jg=rand(1:sizey(conf))
    while !is_entry(conf,updt.ig,updt.jg)
        updt.ig=rand(1:sizex(conf))
        updt.jg=rand(1:sizey(conf))
    end

end
