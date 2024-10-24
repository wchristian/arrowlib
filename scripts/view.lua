-- This is where we render and update the arrows and boxes
local const = require("__arrowlib__/lib/const")
local position = require("__arrowlib__/lib/position")

local view = {}

local get_arg = function(prop)

    -- Overwrite prop.color if the sprite is not allowed for coloring
    for _, s in pairs(const.arrow.disallow_coloring) do
        if prop.sprite == s then
            prop.color = nil
            break
        end
    end
    local arg = {
        -- sprite = "utility/alert_arrow",
        sprite = prop.sprite,
        tint = prop.color,
        surface = prop.surface,
        time_to_live = prop.time_to_live,
        x_scale = prop.scale,
        y_scale = prop.scale
    }
    if prop.type == const.types.relative_from_entity then
        arg.target = prop.target
        arg.target_offset = {
            x = prop.offx,
            y = prop.offy
        }
    else
        arg.target = position.add(prop.target, {prop.offx, prop.offy})
        arg.target_offset = nil
    end

    if prop.type == const.types.absolute then
        arg.orientation = prop.orientation
    else
        arg.orientation = position.get_angle_corrected(prop.angle_deg)
    end
    return arg
end

view.draw = function(prop)
    local arg = get_arg(prop)

    -- Draw & remember the arrow
    local id = rendering.draw_sprite(arg).id

    -- Compose the id and return
    local idx
    if prop.surface.index then
        idx = prop.surface.index
    else
        idx = game.get_surface(prop.surface)
    end
    return idx .. "_" .. id, id, nil
end

view.destroy = function(id)
    if id and rendering.get_object_by_id(id).valid then
        rendering.get_object_by_id(id).destroy()
    end
end

view.update = function(mstr)
    local arg = get_arg(mstr.prop)
    local render = rendering.get_object_by_id(mstr.arrow_id)
    render.target = {entity = arg.target, offset = arg.target_offset or {0, 0}}
    render.orientation = 0.5
    render.orientation_target = arg.target

end

return view
