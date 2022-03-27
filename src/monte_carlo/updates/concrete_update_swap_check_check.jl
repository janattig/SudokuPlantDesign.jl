###################
# SWAP CHECKS(turn check into different check)
###################

mutable struct UpdateSwapCheckCheck <: AbstractUpdate

    # position
    i1 :: Int64
    j1 :: Int64

    # position
    i2 :: Int64
    j2 :: Int64

    # check
    check_1 :: Int64

    # check
    check_2 :: Int64


    # constructor
    function UpdateSwapCheckCheck()
        return new(-1,-1,-1,-1,-1,-1)
    end

end
export UpdateSwapCheckCheck






function apply_update!(conf :: C, updt :: UpdateSwapCheckCheck) where {C <: CheckConfiguration}
    # setze check_1 auf i2,j2 und check_2 auf i1,j1
    set_check!(conf,updt.i2,updt.j2,updt.check_1)
    set_check!(conf,updt.i1,updt.j1,updt.check_2)
end
function reverse_update!(conf :: C, updt :: UpdateSwapCheckCheck) where {C <: CheckConfiguration}
    # setze check_1 auf i1,j1 und check_2 auf i2,j2
    set_check!(conf,updt.i1,updt.j1,updt.check_1)
    set_check!(conf,updt.i2,updt.j2,updt.check_2)
end

function generate!(updt :: UpdateSwapCheckCheck, conf :: C) where {C <: CheckConfiguration}
    # suche random coordinates und behalte wenn check ist
    updt.i1=rand(1:sizex(conf))
    updt.j1=rand(1:sizey(conf))
    while !is_check(conf,updt.i1,updt.j1)
        updt.i1=rand(1:sizex(conf))
        updt.j1=rand(1:sizey(conf))
    end
    updt.check_1=get_check(conf,updt.i1,updt.j1)

    # suche random coordinates und behalte wenn anderer check ist
    updt.i2=rand(1:sizex(conf))
    updt.j2=rand(1:sizey(conf))
    while !is_check(conf,updt.i2,updt.j2) || updt.check_1==get_check(conf,updt.i2,updt.j2)
        updt.i2=rand(1:sizex(conf))
        updt.j2=rand(1:sizey(conf))
    end
    updt.check_2=get_check(conf,updt.i2,updt.j2)

end
