########################
# Show configuration (PyPlot)
########################

function show_configuration(
        lconf :: LC
        ;
        zoom = 1.0,
        title_zoom = 1.0,
        text_zoom = 1.0,
        cmap="gist_rainbow",
        check_labels::Bool=false,
        dpi = 300,
        show_coordinates::Bool=false,
        plot_position_order::Bool=false,
        omit_labels :: Vector{<:Int} = Int[]
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # show the configuration
    show_configuration(lconf.configuration, zoom=zoom, title_zoom=title_zoom, cmap=cmap, check_labels=false, dpi=dpi, show_coordinates=show_coordinates)

    # plot the labels and indices

    # generate labels (including indices)
    plot_labels = deepcopy(lconf.labels)
    # plot labels
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            if !is_empty(lconf.configuration, i,j)
                relevant_labels = plot_labels[i,j][setdiff(1:length(plot_labels[i,j]), omit_labels)]
                insert!(relevant_labels, 1, "#"*string(lconf.indices[i,j]))
                if is_check(lconf.configuration, i,j) && check_labels
                    insert!(relevant_labels, 1, "check("*string(get_check(lconf.configuration,i,j))*")")
                end
                plot_label = relevant_labels[1]
                for l in relevant_labels[2:end]
                    plot_label = plot_label * "\n" * l
                end
                # label the check with a the respective labels
                text(i-0.5,j-0.5, plot_label, horizontalalignment="center", verticalalignment="center", fontsize=8*text_zoom*zoom)
            else
                # label empty field by X
                text(i-0.5,j-0.5, "X", horizontalalignment="center", verticalalignment="center", fontsize=8*text_zoom*zoom)
            end
        end
    end

    if plot_position_order
        xvals = zeros(maximum(lconf.indices))
        yvals = zeros(maximum(lconf.indices))

        for i in 1:sizex(lconf)
            for j in 1:sizey(lconf)
                if lconf.indices[i,j] > 0
                    xvals[lconf.indices[i,j]] = i - 0.5
                    yvals[lconf.indices[i,j]] = j - 0.5
                end
            end
        end

        plot(xvals, yvals, lw=15*zoom, alpha=0.4, color="r", zorder=2)
    end

end





###############################################
# save and load configuration (TODO)
###############################################
