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
        show_coordinates::Bool=false
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # show the configuration
    show_configuration(lconf.configuration, zoom=zoom, title_zoom=title_zoom, cmap=cmap, check_labels=false, dpi=dpi, show_coordinates=show_coordinates)

    # plot the labels and indices

    # generate labels (including indices)
    plot_labels = deepcopy(lconf.labels)
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            insert!(plot_labels[i,j], 1, "#"*string(lconf.indices[i,j]))
            if is_check(lconf.configuration, i,j) && check_labels
                insert!(plot_labels[i,j], 1, "check("*string(get_check(lconf.configuration,i,j))*")")
            end
        end
    end

    # plot labels
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            if !is_empty(lconf.configuration, i,j)
                plot_label = plot_labels[i,j][1]
                for l in plot_labels[i,j][2:end]
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

end




###############################################
# save and load configuration (TODO)
###############################################
