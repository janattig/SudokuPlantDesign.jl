# a single monte carlo update
function mc_update!(C, T, updates, K)
    K_old = K(C)
    updt  = rand(updates)
    generate!(updt, C)
    apply_update!(C, updt)
    K_new = K(C)

    alpha = exp(-(K_new - K_old)/T)
    if rand() < alpha
        # accept, do nothing
    else
        # refuse, revert the update
        reverse_update!(C, updt)
    end
    return nothing
end
export mc_update!



function optimize_design!(C, updates, K, num_updates = 100000, beta = t -> 1*exp(-7*t) * (1 + 0.2*cos(t*30*pi)))
    cost_values = zeros(num_updates)
    @showprogress "Optimizing Design ... " for i in 1:length(cost_values)
        mc_update!(C, beta(i/length(cost_values)), updates, K)
        cost_values[i] = K(C)
    end
    return cost_values
end
export optimize_design!
