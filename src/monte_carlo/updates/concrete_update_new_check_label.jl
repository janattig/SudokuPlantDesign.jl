###################
# NEW CHECK LABEL (turn check into different check)
###################

mutable struct UpdateNewCheckLabel <: AbstractUpdate

    # position
    i :: Int64
    j :: Int64

    # check
    check_pre :: Int64

    # check
    check_post :: Int64


    # constructor
    function UpdateNewCheckLabel()
        return new(-1,-1,-1,-1)
    end

end

function apply_update!(conf :: C, updt :: UpdateNewCheckLabel) where {C <: CheckConfiguration}
    # set the previous thing in the configuration
    set_check!(conf, updt.i,updt.j, updt.check_post)
end
function reverse_update!(conf :: C, updt :: UpdateNewCheckLabel) where {C <: CheckConfiguration}
    # set the check in the configuration
    set_check!(conf, updt.i,updt.j, updt.check_pre)
end

function generate!(updt :: UpdateNewCheckLabel, conf :: C) where {C <: CheckConfiguration}
    # find suitable position
    updt.i = rand(1:sizex(conf))
    updt.j = rand(1:sizey(conf))
    while !is_check(conf, updt.i,updt.j)
        updt.i = rand(1:sizex(conf))
        updt.j = rand(1:sizey(conf))
    end
    # find random check and build new update
    updt.check_pre  = get_check(conf, updt.i,updt.j)
    updt.check_post = rand(1:conf.N)
    while updt.check_pre == updt.check_post
        updt.check_post = rand(1:conf.N)
    end
    # return nothing
    return nothing
end
