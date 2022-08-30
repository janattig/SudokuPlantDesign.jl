function fill_indices_snake_x!(
        lconf :: LC,
        di,dj
        ;
        index_for_empty :: Bool = true
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_i = 1
    min_j = 1
    max_i = sizex(lconf)
    max_j = sizey(lconf)

    i = min_i
    j = min_j

    if di < 0
        i = max_i
    end
    if dj < 0
        j = max_j
    end


    # set current index
    current_index = 1


    # let the snake go through the indices
    while min_i <= i <= max_i && min_j <= j <= max_j

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, i,j)
            # set the index
            lconf.indices[i,j] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along x direction
        i = i + di

        # if coming to the boundary, reflect and move along y
        if i > max_i
            di = -1
            i = i-1
            j = j+dj
        elseif i < min_i
            di = +1
            i = i+1
            j = j+dj
        end

    end
end
export fill_indices_snake_x!


function fill_indices_snake_y!(
        lconf :: LC,
        di,dj
        ;
        index_for_empty :: Bool = true
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_i = 1
    min_j = 1
    max_i = sizex(lconf)
    max_j = sizey(lconf)

    i = min_i
    j = min_j

    if di < 0
        i = max_i
    end
    if dj < 0
        j = max_j
    end


    # set current index
    current_index = 1


    # let the snake go through the indices
    while min_i <= i <= max_i && min_j <= j <= max_j

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, i,j)
            # set the index
            lconf.indices[i,j] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along y direction
        j = j + dj

        # if coming to the boundary, reflect and move along x
        if j > max_j
            dj = -1
            j = j-1
            i = i+di
        elseif j < min_j
            dj = +1
            j = j+1
            i = i+di
        end

    end
end
export fill_indices_snake_y!


function fill_indices_lines_x!(
        lconf :: LC,
        di,dj
        ;
        index_for_empty :: Bool = true
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_i = 1
    min_j = 1
    max_i = sizex(lconf)
    max_j = sizey(lconf)

    i = min_i
    j = min_j

    if di < 0
        i = max_i
    end
    if dj < 0
        j = max_j
    end


    # set current index
    current_index = 1


    # let the snake go through the indices
    while min_i <= i <= max_i && min_j <= j <= max_j

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, i,j)
            # set the index
            lconf.indices[i,j] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along x direction
        i = i + di

        # if coming to the boundary, reflect and move along y
        if i > max_i
            di = +1
            i = min_i
            j = j+dj
        elseif i < min_i
            di = -1
            i = max_i
            j = j+dj
        end

    end
end
export fill_indices_lines_x!



function fill_indices_lines_y!(
        lconf :: LC,
        di,dj
        ;
        index_for_empty :: Bool = true
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_i = 1
    min_j = 1
    max_i = sizex(lconf)
    max_j = sizey(lconf)

    i = min_i
    j = min_j

    if di < 0
        i = max_i
    end
    if dj < 0
        j = max_j
    end


    # set current index
    current_index = 1


    # let the snake go through the indices
    while min_i <= i <= max_i && min_j <= j <= max_j

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, i,j)
            # set the index
            lconf.indices[i,j] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along y direction
        j = j + dj

        # if coming to the boundary, reflect and move along x
        if j > max_j
            dj = +1
            j = min_j
            i = i+di
        elseif j < min_j
            dj = -1
            j = max_j
            i = i+di
        end

    end
end
export fill_indices_lines_y!
