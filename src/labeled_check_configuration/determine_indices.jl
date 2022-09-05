function fill_indices_snake_x!(
        lconf :: LC,
        dx,dy
        ;
        index_for_empty :: Bool = true,
        min_x :: Int = -1,
        min_y :: Int = -1,
        max_x :: Int = -1,
        max_y :: Int = -1,
        x :: Int = -1,
        y :: Int = -1,
        start_index :: Int = 1
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_x = (1 <= min_x <= sizex(lconf)) ? min_x : 1
    min_y = (1 <= min_y <= sizey(lconf)) ? min_y : 1
    max_x = (1 <= max_x <= sizex(lconf)) ? max_x : sizex(lconf)
    max_y = (1 <= max_y <= sizey(lconf)) ? max_y : sizey(lconf)

    x = (min_x <= x <= max_x) ? x : (dx<0 ? max_x : min_x)
    y = (min_y <= y <= max_y) ? y : (dy<0 ? max_y : min_y)


    # set current index
    current_index = start_index


    # let the snake go through the indices
    while min_x <= x <= max_x && min_y <= y <= max_y

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, x,y)
            # set the index
            lconf.indices[x,y] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along x direction
        x = x + dx

        # if coming to the boundary, reflect and move along y
        if x > max_x
            dx = -1
            x = x-1
            y = y+dy
        elseif x < min_x
            dx = +1
            x = x+1
            y = y+dy
        end

    end
end
export fill_indices_snake_x!


function fill_indices_snake_y!(
        lconf :: LC,
        dx,dy
        ;
        index_for_empty :: Bool = true,
        min_x :: Int = -1,
        min_y :: Int = -1,
        max_x :: Int = -1,
        max_y :: Int = -1,
        x :: Int = -1,
        y :: Int = -1,
        start_index :: Int = 1
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_x = (1 <= min_x <= sizex(lconf)) ? min_x : 1
    min_y = (1 <= min_y <= sizey(lconf)) ? min_y : 1
    max_x = (1 <= max_x <= sizex(lconf)) ? max_x : sizex(lconf)
    max_y = (1 <= max_y <= sizey(lconf)) ? max_y : sizey(lconf)

    x = (min_x <= x <= max_x) ? x : (dx<0 ? max_x : min_x)
    y = (min_y <= y <= max_y) ? y : (dy<0 ? max_y : min_y)


    # set current index
    current_index = start_index


    # let the snake go through the indices
    while min_x <= x <= max_x && min_y <= y <= max_y

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, x,y)
            # set the index
            lconf.indices[x,y] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along y direction
        y = y + dy

        # if coming to the boundary, reflect and move along x
        if y > max_y
            dy = -1
            y = y-1
            x = x+dx
        elseif y < min_y
            dy = +1
            y = y+1
            x = x+dx
        end

    end
end
export fill_indices_snake_y!


function fill_indices_lines_x!(
        lconf :: LC,
        dx,dy
        ;
        index_for_empty :: Bool = true,
        min_x :: Int = -1,
        min_y :: Int = -1,
        max_x :: Int = -1,
        max_y :: Int = -1,
        x :: Int = -1,
        y :: Int = -1,
        start_index :: Int = 1
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_x = (1 <= min_x <= sizex(lconf)) ? min_x : 1
    min_y = (1 <= min_y <= sizey(lconf)) ? min_y : 1
    max_x = (1 <= max_x <= sizex(lconf)) ? max_x : sizex(lconf)
    max_y = (1 <= max_y <= sizey(lconf)) ? max_y : sizey(lconf)

    x = (min_x <= x <= max_x) ? x : (dx<0 ? max_x : min_x)
    y = (min_y <= y <= max_y) ? y : (dy<0 ? max_y : min_y)


    # set current index
    current_index = start_index


    # let the snake go through the indices
    while min_x <= x <= max_x && min_y <= y <= max_y

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, x,y)
            # set the index
            lconf.indices[x,y] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along x direction
        x = x + dx

        # if coming to the boundary, reflect and move along y
        if x > max_x
            dx = +1
            x = min_x
            y = y+dy
        elseif x < min_x
            dx = -1
            x = max_x
            y = y+dy
        end

    end
end
export fill_indices_lines_x!



function fill_indices_lines_y!(
        lconf :: LC,
        dx,dy
        ;
        index_for_empty :: Bool = true,
        min_x :: Int = -1,
        min_y :: Int = -1,
        max_x :: Int = -1,
        max_y :: Int = -1,
        x :: Int = -1,
        y :: Int = -1,
        start_index :: Int = 1
    ) where {C <: CheckConfiguration, LC <: LabeledCheckConfiguration{C}}

    # set the coordinate boundaries and start
    min_x = (1 <= min_x <= sizex(lconf)) ? min_x : 1
    min_y = (1 <= min_y <= sizey(lconf)) ? min_y : 1
    max_x = (1 <= max_x <= sizex(lconf)) ? max_x : sizex(lconf)
    max_y = (1 <= max_y <= sizey(lconf)) ? max_y : sizey(lconf)

    x = (min_x <= x <= max_x) ? x : (dx<0 ? max_x : min_x)
    y = (min_y <= y <= max_y) ? y : (dy<0 ? max_y : min_y)


    # set current index
    current_index = start_index


    # let the snake go through the indices
    while min_x <= x <= max_x && min_y <= y <= max_y

        # only give index if desired
        if index_for_empty || !is_empty(lconf.configuration, x,y)
            # set the index
            lconf.indices[x,y] = current_index
            # increment the current index
            current_index = current_index + 1
        end

        # move along y direction
        y = y + dy

        # if coming to the boundary, reflect and move along x
        if y > max_y
            dy = +1
            y = min_y
            x = x+dx
        elseif y < min_y
            dy = -1
            y = max_y
            x = x+dx
        end

    end
end
export fill_indices_lines_y!
