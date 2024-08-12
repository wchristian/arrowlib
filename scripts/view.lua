-- This is where we render and update the arrows and boxes
local const = require("__arrowlib__/lib/const")
local position = require("__arrowlib__/lib/position")

local view = {}

------------------------------------------------------------------------------------------
-- Rendering
------------------------------------------------------------------------------------------

-- local draw_arrow = function(p, drew)
--     -- Early exit if we already drew this one
--     if drew and drew.arrow and view.is_valid(drew.arrow) then
--         return
--     end

--     local prop = {
--         sprite = "utility/alert_arrow",
--         orientation = mutil.get_angle_corrected(drew.data.prop.angle_deg),
--         -- orientation_target = e,
--         target = p.character,
--         target_offset = {
--             x = drew.data.prop.offx,
--             y = drew.data.prop.offy
--         },
--         surface = drew.data.entity.surface,
--         time_to_live = settings.global["gh_arrow-time-to-live"].value * 60,
--         x_scale = 2,
--         y_scale = 2
--     }

--     -- Draw & remember the box
--     drew.arrow = view.draw_sprite(prop)
-- end

-- local remove_arrow = function(p, drew)
--     if not drew or not drew.arrow then
--         return
--     end
--     if view.is_valid(drew.arrow) then
--         view.destroy(drew.arrow)
--     end
-- end

-- local update_arrow = function(p, drew)
--     -- Sanity check
--     if not drew or not drew.arrow then
--         game.print("Not drawn")
--         return
--     end
--     if not view.is_valid(drew.arrow) then
--         game.print("Not valid")
--         return
--     end

--     -- Update orientation
--     view.set_orientation(drew.arrow, mutil.get_angle_corrected(drew.data.prop.angle_deg))

--     local target = p.character
--     local target_offset = {
--         x = drew.data.prop.offx,
--         y = drew.data.prop.offy
--     }
--     -- Update offset
--     view.set_target(drew.arrow, target, target_offset)
-- end

-- local remove_render = function(gp, drew_id)
--     -- Get some variables to work with
--     local arr = gp.drew[drew_id]

--     -- Remove sprites and array entry
--     if arr.arrow then
--         view.destroy(arr.arrow)
--     end
--     if arr.box then
--         view.destroy(arr.box)
--     end
--     gp.drew[drew_id] = nil
-- end

-- local remove_all_renders = function(player)
--     local gp = global_player.get(player)

--     -- Early exit if we did not draw anything
--     if not gp.drew then
--         return
--     end

--     -- Remove all renders
--     for id, arr in pairs(gp.drew) do
--         remove_render(gp, id)
--     end

--     -- Clear all arrays
--     gp.to_track = {}
--     gp.scan = {}
-- end

local get_arg = function(prop)

    local arg = {
        sprite = "utility/alert_arrow",
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
    local id = rendering.draw_sprite(arg)

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
    if id and rendering.is_valid(id) then
        rendering.destroy(id)
    end
end

view.update = function(mstr)
    local arg = get_arg(mstr.prop)
    rendering.set_target(mstr.arrow_id, arg.target, arg.target_offset or {0, 0})
    rendering.set_orientation(mstr.arrow_id, arg.orientation)

end

return view
