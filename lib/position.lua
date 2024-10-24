local position = {}

------------------------------------------------------------------------------------------
-- Position util
------------------------------------------------------------------------------------------

--- @param target any
--- @return boolean
local is_map_position = function(target)
    if not target then
        return false
    end
    local is_shorthand = (#target == 2 and tonumber(target[1]) and tonumber(target[2])) or false
    local is_explicit = (target.x and target.y) or false
    return (is_shorthand or is_explicit) --[[@as boolean]]
end

--- @param target any
--- @return boolean
local is_bounding_box = function(target)
    if not target then
        return false
    end
    local is_shorthand = (#target == 2 and type(target[1] == "userdata") and type(target[2] == "userdata")) or false
    if is_shorthand then
        is_shorthand = is_map_position(target[1]) and is_map_position(target[2])
    end
    local is_explicit = (target.left_top and target.right_bottom) or false
    return (is_shorthand or is_explicit) --[[@as boolean]]
end

--- @param target any
--- @return MapPosition? or `nil`
local get_box_center = function(target)
    if not is_bounding_box(target) then
        return
    end

    local xrb, xlt, yrb, ylt
    if target.left_top and target.right_bottom then
        xrb = target.right_bottom.x
        xlt = target.left_top.x
        yrb = target.right_bottom.y
        ylt = target.left_top.y
    else
        if target[1].x and target[1].y and target[2].x and target[2].y then
            xlt = target[1].x
            ylt = target[1].y
            xrb = target[2].x
            yrb = target[2].y
        else
            xlt = target[1][1]
            ylt = target[1][2]
            xrb = target[2][1]
            yrb = target[2][2]
        end
    end

    local pos = {
        x = (xrb + xlt) / 2,
        y = (yrb + ylt) / 2
    }

    return pos --[[@as MapPosition]]
end

position.get_normalized = function(target)
    local data

    if target.position then
        if target.position.x and target.position.y then
            data = target
        else
            data = {
                position = {
                    x = target.position[1],
                    y = target.position[2]
                }
            }
        end
    else
        if is_map_position(target) then
            if target.x and target.y then
                data = {
                    position = {
                        x = target.x,
                        y = target.y
                    }
                }
            else
                data = {
                    position = {
                        x = target[1],
                        y = target[2]
                    }
                }
            end
        elseif is_bounding_box(target) then
            local pos = get_box_center(target)
            if pos then
                data = {
                    position = {
                        x = pos.x,
                        y = pos.y
                    }
                }
            end
        end
    end

    return data

end

--- @param target any
--- @return boolean
position.is_valid = function(target)
    -- Check if target is a userdata
    if not target or type(target) ~= "userdata" then
        return false
    end

    -- Check if target has key position
    if target.position then
        return true
    end

    -- Check if target is map position or bounding box
    if is_map_position(target) or is_bounding_box(target) then
        return true
    end

    -- Checks fail fall through
    return false

end

position.get_angle_corrected = function(angle)
    if not angle then
        return 0
    end
    return ((angle + 90) / 360) or 0
end

position.add = function(first, second)
    local pos1 = position.get_normalized(first).position
    local pos2 = position.get_normalized(second).position

    local x1 = pos1.x or pos1[1]
    local y1 = pos1.y or pos1[2]
    local x2 = pos2.x or pos2[1]
    local y2 = pos2.y or pos2[2]
    if pos1.x then
        return {
            x = x1 + x2,
            y = y1 + y2
        }
    else
        return {x1 + x2, y1 + y2}
    end
end

return position
