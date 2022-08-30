########################
# Show configuration (PyPlot)
########################

function show_configuration(
        lconf :: LC
        ;
        zoom = 0.2,
        cmap="gist_rainbow",
        check_labels=false,
        dpi = 300
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # show the configuration
    show_configuration(lconf.configuration, zoom=zoom, cmap=cmap, check_labels=false, dpi=dpi)

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

    # determine zoom
    zoom = 0.05

    # plot labels
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            if !is_empty(conf, i,j)
                plot_label = plot_labels[i,j][1]
                for l in plot_labels[i,j][2:end]
                    plot_label = plot_label * "\n" * l
                end
                # label the check with a the respective labels
                text(i-0.5,j-0.5, plot_label, horizontalalignment="center", verticalalignment="center", fontsize=30*zoom)
            else
                # label empty field by X
                text(i-0.5,j-0.5, "X", horizontalalignment="center", verticalalignment="center", fontsize=30*zoom)
            end
        end
    end

end




###############################################
# save and load configuration (TODO)
###############################################
