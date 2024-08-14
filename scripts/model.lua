-- This is where we keep track of all the arrows and the data under them
local const = require("__arrowlib__/lib/const")

local model = {}

model.update_settings = function(data)
end

model.get_offset = function()
    return global.arrowlib.arrow_settings.ARROW_OFFSET
end

model.get_time_to_live = function()
    return global.arrowlib.arrow_settings.ARROW_TIME_TO_LIVE
end

model.get_scale = function()
    return global.arrowlib.arrow_settings.ARROW_SCALE
end

model.get_sprite = function()
    if not global.arrowlib.arrow_settings.ARROW_SPRITE then
        global.arrowlib.arrow_settings.ARROW_SPRITE = const.arrow.SPRITE
    end
    return global.arrowlib.arrow_settings.ARROW_SPRITE
end

model.get_arrow_color = function()
    if not global.arrowlib.arrow_settings.ARROW_SPRITE_COLOR then
        global.arrowlib.arrow_settings.ARROW_SPRITE_COLOR = const.arrow.SPRITE_COLOR
    end
    return global.arrowlib.arrow_settings.ARROW_SPRITE_COLOR
end

model.store = function(id, data, prop, arrow_id, box_id)
    global.arrowlib.arrows[id] = {
        data = data,
        prop = prop,
        arrow_id = arrow_id,
        box_id = box_id
    }
end

model.remove = function(id)
    global.arrowlib.arrows[id] = nil
end

model.get = function(id)
    return global.arrowlib.arrows[id]
end

model.get_all = function()
    return global.arrowlib.arrows
end

return model
