function fill_labels!(
        lconf :: LC,
        checkdata :: DataFrame,
        entrydata :: DataFrame
        ;
        shuffle_entries :: Bool = true
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # see if the length of the dataframe is correct
    @assert size(entrydata)[1] == sum(lconf.configuration.configuration .== 0) "List of entrydata has wrong length ($(length(entrydata[:,1])), but needs $(sum(lconf.configuration.configuration .== 0))). Please check number of entries!"
    @assert size(checkdata)[1] == lconf.configuration.N "List of checkdata has wrong length ($(length(checkdata[:,1])), but needs $(lconf.configuration.N)). Please check number of checks!"

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



function get_dataframe(
        lconf :: LC
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # create a new dataframe
    df = DataFrame(
        index=Int[],
        x=Int[],y=Int[],
        block_x=Int[], block_y=Int[],
        block=String[],
        check=Int[]
    )

    # write first batch of information
    num_props = 0
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            if lconf.indices[i,j] > 0
                bx = SudokuPlantDesign.get_block_index_x(lconf.configuration, i)
                by = SudokuPlantDesign.get_block_index_y(lconf.configuration, j)
                block = string(bx)*"|"*string(by)
                check = get_check(lconf.configuration, i,j)
                num_props = length(lconf.labels[i,j])
                push!(df, [lconf.indices[i,j],i,j,bx,by,block,check])
            end
        end
    end

    # sort the dataframe
    sort!(df)


    # make new dataframe only for additional information
    names = [:index, :genotype]
    cols  = [deepcopy(df[!,:index]), ["NA" for i in 1:size(df)[1]]]
    for p in 1:num_props-1
        push!(names, Symbol("property_"*string(p)))
        push!(cols, ["NA" for i in 1:size(df)[1]])
    end
    df_add = DataFrame(cols, names)

    # write additional properties
    for i in 1:sizex(lconf)
        for j in 1:sizey(lconf)
            if lconf.indices[i,j] > 0
                for li in 1:length(lconf.labels[i,j])
                    df_add[df_add.index .== lconf.indices[i,j],li+1] .= lconf.labels[i,j][li]
                end
            end
        end
    end

    # sort the dataframe
    sort!(df_add)

    # join the two dataframes by index
    df = innerjoin(df, df_add, on=:index)

    # sort the dataframe
    sort!(df)

    # return the dataframe
    return df
end
export get_dataframe
