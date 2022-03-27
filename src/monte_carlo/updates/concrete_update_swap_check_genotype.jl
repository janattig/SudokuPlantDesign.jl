###################
# SWAP A CHECK WITH A GENOTYPE
###################

mutable struct UpdateSwapCheckGenotype <: AbstractUpdate

    # position
    ic :: Int64
    jc :: Int64

    # position
    ig :: Int64
    jg :: Int64

    # check
    check :: Int64



    # constructor
    function UpdateSwapCheckGenotype()
        return new(-1,-1,-1,-1,-1)
    end

end

function apply_update!(conf :: C, updt :: UpdateSwapCheckGenotype) where {C <: CheckConfiguration}
    # setze check auf ig,jg und genotype auf ic,jc
    set_check!(conf,updt.ig,updt.jg,updt.check)
    set_genotype!(conf,updt.ic,updt.jc)
end
function reverse_update!(conf :: C, updt :: UpdateSwapCheckGenotype) where {C <: CheckConfiguration}
    # setze check auf ic,jc und genotype auf ig,jg
    set_check!(conf,updt.ic,updt.jc,updt.check)
    set_genotype!(conf,updt.ig,updt.jg)
end

function generate!(updt :: UpdateSwapCheckGenotype, conf :: C) where {C <: CheckConfiguration}
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
    while !is_genotype(conf,updt.ig,updt.jg)
        updt.ig=rand(1:sizex(conf))
        updt.jg=rand(1:sizey(conf))
    end

end
