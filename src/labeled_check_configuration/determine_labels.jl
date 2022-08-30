function fill_labels!(
        lconf :: LC,
        checkdata :: DataFrame,
        entrydata :: DataFrame
        ;
        shuffle_entries :: Bool = true
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # see if the length of the dataframe is correct
    @assert length(entrydata[:,1]) == sum(lconf.configuration.configuration .== 0) "List of entrydata has wrong length ($(length(entrydata[:,1])), but needs $(sum(lconf.configuration.configuration .== 0))). Please check number of entries!"
    @assert length(checkdata[:,1]) == lconf.configuration.N "List of checkdata has wrong length ($(length(checkdata[:,1])), but needs $(lconf.configuration.N)). Please check number of checks!"

    # maybe shuffle the entrydata
    if shuffle_entries
        entrydata = deepcopy(entrydata[shuffle(1:nrow(entrydata)), :])
    end

    # index of the current entry
    current_entry = 1

    # iterate over all plant plots
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            if !is_empty(lconf.configuration, i,j)
                # designate new label, depending on entry or check
                if is_check(lconf.configuration, i,j)
                    lconf.labels[i,j] = collect(checkdata[get_check(lconf.configuration, i,j),:])
                else
                    lconf.labels[i,j] = collect(entrydata[current_entry,:])
                    current_entry += 1
                end
            end
        end
    end

end
export fill_labels!
