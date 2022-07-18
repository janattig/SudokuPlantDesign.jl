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
    show_configuration(lconf.configuration, zoom=zoom, cmap=cmap, check_labels=check_labels, dpi=dpi)

    # TODO plot the labels and indices

end





###############################################
# save and load configuration (TODO)
###############################################
