# a single monte carlo update
function mc_update!(C, T, updatemoves, K)
    K_old = K(C)
    updt  = rand(updatemoves)
    generate!(updt, C)
    apply_update!(C, updt)
    K_new = K(C)

    alpha = exp(-(K_new - K_old)/T)
    if rand() < alpha
        # accept, do nothing
    else
        # refuse, revert the update
        reverse_update!(C, move)
    end
    return nothing
end
