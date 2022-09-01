########################
# Init configuration
########################



function empty_plots!(
        conf :: C,
        i_min :: Int64, i_max :: Int64,
        j_min :: Int64, j_max :: Int64
    ) where {C <: CheckConfiguration}

    # call subfunction
    empty_plots!(conf, i_min:i_max, j_min:j_max)

end
function empty_plots!(
        conf :: C,
        i_range :: UnitRange{Int64},
        j_range :: UnitRange{Int64}
    ) where {C <: CheckConfiguration}

    # set every element to -1
    for i in i_range
        for j in j_range
            set_empty!(conf, i,j)
        end
    end

end
export empty_plots!

function empty_plots_in_block!(
        conf :: C,
        bi :: Int64,
        bj :: Int64
    ) where {C <: CheckConfiguration}

    # set every element to -1
    for i in 1:blocksizex(conf, bi,bj)
        for j in 1:blocksizey(conf, bi,bj)
            set_empty!(conf, bi,bj, i,j)
        end
    end

end
export empty_plots_in_block!





function initialize_checks!(conf :: C, num_checks :: Int64) where {C <: CheckConfiguration}
    # the total number of available plots has to be bigger than the number of entries
    @assert conf.num_plots_total >= num_checks "Not enough space for $(num_checks) checks in the design!"
    # set every non-(-1) element to 0
    for i in 1:sizex(conf)
        for j in 1:sizey(conf)
            if !is_empty(conf, i,j)
                set_entry!(conf, i,j)
            end
        end
    end
    # find position for every check
    i = rand(1:sizex(conf))
    j = rand(1:sizey(conf))
    for x in 1:num_checks
        # find random check label
        c = rand(1:conf.N)
        # find random positions
        while !is_entry(conf, i,j)
            i = rand(1:sizex(conf))
            j = rand(1:sizey(conf))
        end
        # set the check
        set_check!(conf, i,j, c)
    end
end
export initialize_checks!

function initialize_checks_per_block!(conf :: C) where {C <: CheckConfiguration}
    # iterate over all blocks
    for bi in 1:blocksx(conf)
    for bj in 1:blocksy(conf)
        # set every non-(-1) element to 0 and count these elements
        num_entries_in_block = 0
        for i in 1:blocksizex(conf, bi,bj)
        for j in 1:blocksizey(conf, bi,bj)
            if !is_empty(conf, bi,bj, i,j)
                set_entry!(conf, bi,bj, i,j)
                num_entries_in_block += 1
            end
        end
        end
        # maybe warn if not possible to distribute the number of checks
        if 0 < num_entries_in_block < conf.N
            @warn "Block ($(bi),$(bj)) has only $(num_entries_in_block) available fields, cannot distribute $(conf.N) checks!"
        end
        # find position for every check
        i = rand(1:blocksizex(conf, bi,bj))
        j = rand(1:blocksizey(conf, bi,bj))
        for c in 1:min(conf.N,num_entries_in_block)
            # find random positions
            while !is_entry(conf, bi,bj, i,j)
                i = rand(1:blocksizex(conf, bi,bj))
                j = rand(1:blocksizey(conf, bi,bj))
            end
            # set the check
            set_check!(conf, bi,bj, i,j, c)
        end
    end
    end
end
export initialize_checks_per_block!

function initialize_entries!(conf :: C, num_entries :: Int64) where {C <: CheckConfiguration}
    # the total number of available plots has to be bigger than the number of entries
    @assert conf.num_plots_total >= num_entries "Not enough space for $(num_entries) entries in the design!"
    # set every non-(-1) element to a random check
    for i in 1:sizex(conf)
        for j in 1:sizey(conf)
            if !is_empty(conf, i,j)
                set_check!(conf, i,j, rand(1:conf.N))
            end
        end
    end
    # find position for every entry
    i = rand(1:sizex(conf))
    j = rand(1:sizey(conf))
    for x in 1:num_entries
        # find random positions
        while !is_check(conf, i,j)
            i = rand(1:sizex(conf))
            j = rand(1:sizey(conf))
        end
        # set the entry
        set_entry!(conf, i,j)
    end
end
export initialize_entries!





########################
# Show configuration (PyPlot)
########################

function print_info(
        conf :: C
    ) where {C <: CheckConfiguration}

    println("Sudoku design with ", conf.N, " different checks")
    println("- field size: ",sizex(conf)*sizey(conf), "  (=$(sizex(conf))x$(sizey(conf)) plots)")
    println("   -> blocks: ",blocksx(conf)*blocksy(conf), " (=$(blocksx(conf))x$(blocksy(conf)) blocks)")
    println("   -> empty plots:  ", sum(conf.configuration .== -1))
    println("   -> usable plots: ", sum(conf.configuration .!= -1))
    println("- # entries: ",conf.num_plots_total - conf.num_checks_total)
    println("- # checks:  ",conf.num_checks_total, "  (", round(100*conf.num_checks_total / conf.num_plots_total, digits=2), "% of plots)")
    for i in 1:conf.N
        println("    -> #($(i)): ",conf.num_checks[i], "  (", round(100*conf.num_checks[i] / conf.num_checks_total, digits=2), "% of checks)")
    end

end
export print_info

function show_configuration(
        conf :: C
        ;
        zoom = 1.0,
        title_zoom = 1.0,
        cmap="gist_rainbow",
		check_labels::Bool=true,
        dpi = 300,
        show_coordinates::Bool=false
    ) where {C <: CheckConfiguration}

    # new figure
    figure(figsize=size(conf.configuration) .* zoom, dpi=dpi)

    # show the configuration
    imshow(
        collect(conf.configuration'),
        origin="lower",
        interpolation="None",
        alpha=1,
        extent = (0,sizex(conf),0,sizey(conf)),
        cmap = cmap,
        vmin = -1,
        vmax = conf.N
    )

    # make lines surrounding the blocks
    sx = [size(B)[1] for B in blocks(conf.configuration)[:,1]]
    for i in 2:length(sx)
        sx[i] += sx[i-1]
    end
    sx = vcat([0],sx)
    sy = [size(B)[2] for B in blocks(conf.configuration)[1,:]]
    for i in 2:length(sy)
        sy[i] += sy[i-1]
    end
    sy = vcat([0],sy)

    for x in sx
        plot([x,x], [sy[1], sy[end]], color="k")
    end
    for y in sy
        plot([sx[1],sx[end]], [y, y], color="k")
    end


    # text
	if check_labels
		for i in 1:sizex(conf)
			for j in 1:sizey(conf)
				if is_check(conf, i,j)
					# label the check with a number
					text(i-0.5,j-0.5, "$(get_check(conf, i,j))", horizontalalignment="center", verticalalignment="center", fontsize=30*zoom)
				elseif is_empty(conf, i,j)
					# label empty field by X
					text(i-0.5,j-0.5, "X", horizontalalignment="center", verticalalignment="center", fontsize=30*zoom)
				end
			end
		end
	end


    # no axis
    axis("off")

    # some title
    title("$(sizex(conf))x$(sizey(conf)) Design  ($(blocksx(conf))x$(blocksy(conf)) blocks)", fontsize=60*zoom*title_zoom)

    # maybe coordinates
    if show_coordinates
        quiver(sizex(conf)*0.5 + 1, -1.0, 1.0, 0.0, units="xy", scale=2/(sizex(conf)), pivot="tip", width=0.1)
        quiver(-1.0, sizey(conf)*0.5 + 1, 0.0, 1.0, units="xy", scale=2/(sizey(conf)), pivot="tip", width=0.1)

        text(sizex(conf)*0.5 + 1.3, -1.0, "x", horizontalalignment="left", verticalalignment="center", fontsize=30*zoom)
        text(-1.0, sizey(conf)*0.5 + 1.3, "y", horizontalalignment="center", verticalalignment="bottom", fontsize=30*zoom)

        xlim(-1.5, sizex(conf)+1.5)
        ylim(-1.5, sizey(conf)+0.5)
    else
        xlim(-0.5, sizex(conf)+0.5)
        ylim(-0.5, sizey(conf)+0.5)
    end

    # tighten the layout
    tight_layout()
end
export show_configuration






###############################################
# save and load configuration
###############################################

function save_configuration(conf :: C, filename :: String) where {C <: CheckConfiguration}
    f = open(filename, "w")

    # erste zeile: anzahl verschiedener checks
    println(f, conf.N)

    # zweite / dritte zeile: groesse blocke in x und y richtung
    blocksizesx = [blocksizex(conf, i,1) for i in 1:blocksx(conf)]
    blocksizesy = [blocksizey(conf, 1,j) for j in 1:blocksy(conf)]
    for bx in blocksizesx
        print(f, bx, " ")
    end
    println(f)
    for by in blocksizesy
        print(f, by, " ")
    end
    println(f)

    # jede weitere zeile: ein element
    for i in 1:sizex(conf)
        for j in 1:sizey(conf)
            println(f, i, ",", j, ": ", get_check(conf, i,j))
        end
    end

    close(f)
end
export save_configuration

function load_configuration(filename :: String)
    # liest zeilen der datei aus
    f = open(filename, "r")
    lines = strip.(readlines(f))
    close(f)

    numberofchecktypes = Meta.eval(Meta.parse(lines[1]))
    blocksizesx = Int64[Meta.eval(Meta.parse(p)) for p in split(lines[2], " ")]
    blocksizesy = Int64[Meta.eval(Meta.parse(p)) for p in split(lines[3], " ")]

    # generiere neue konfiguration
    conf = get_configuration(blocksizesx, blocksizesy, numberofchecktypes)

    # jede weitere zeile: ein element
    for l in lines[4:end]
        i = Meta.eval(Meta.parse(split(split(l, ": ")[1], ",")[1]))
        j = Meta.eval(Meta.parse(split(split(l, ": ")[1], ",")[2]))
        c = Meta.eval(Meta.parse(split(l, ": ")[2]))
        if c < 0
            set_empty!(conf,i,j)
        elseif c == 0
            set_entry!(conf,i,j)
        else
            set_check!(conf, i,j, c)
        end
    end

    # return configuration
    return conf
end
export load_configuration
