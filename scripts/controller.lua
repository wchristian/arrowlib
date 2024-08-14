-- This is where we take data from the arrow class and transform it to usable data in the model and pass it to the view to actually render stuff
local const = require("__arrowlib__/lib/const")
local position = require("__arrowlib__/lib/position")

local model = require("__arrowlib__/scripts/model")
local view = require("__arrowlib__/scripts/view")

local controller = {}

local get_valid_arrow_sprite = function(sprite)
    if not sprite or not game.is_valid_sprite_path(sprite) then
        return model.get_sprite()
    else
        return sprite
    end
end

local get_pt = function(from, to)
    local from_norm = position.get_normalized(from)
    local to_norm = position.get_normalized(to)
    local pt = {
        first = {
            x = from_norm.position.x,
            y = from_norm.position.y
        },
        second = {
            x = to_norm.position.x,
            y = to_norm.position.y
        }
    }
    pt.delta = {
        -- x = pt.second.x - pt.first.x,
        -- y = pt.second.y - pt.first.y
        x = pt.first.x - pt.second.x,
        y = pt.second.y - pt.first.y
    }
    return pt
end

local calculate_relative = function(data)
    -- Get some variables to work with
    local pt = get_pt(data.source, data.target)

    -- Prepare the return array
    local prop = {}
    if data.source.object_name and data.source.object_name == "LuaEntity" then
        prop.type = const.types.relative_from_entity
    else
        prop.type = const.types.relative_from_position
    end

    -- Do the calculations
    -- Angle calculations
    prop.angle_rad = math.atan2(pt.delta.x, pt.delta.y) + (math.pi / 2)
    prop.angle_deg = prop.angle_rad * (180 / math.pi)

    -- Segmented angle
    local deg_seg = 20
    local angle_corr = prop.angle_deg - (deg_seg / 2)
    prop.angle_deg_seg = math.floor((angle_corr) / deg_seg) * deg_seg

    prop.distance = math.sqrt(pt.delta.x ^ 2 + pt.delta.y ^ 2) - 0.5
    prop.center = position.get_normalized(data.source)
    prop.offset = math.min(prop.distance, data.offset or model.get_offset()) -- Draw the arrow at max 5 meter
    prop.offx = prop.offset * math.cos(prop.angle_rad)
    prop.offy = prop.offset * math.sin(prop.angle_rad)

    return prop
end

local calculate_absolute = function(data)
    -- Get orientation from direction
    local direction = data.source_direction or const.defines.from_top

    -- Prepare the return array
    local prop = {}
    prop.orientation = const.orientation[direction]
    prop.type = const.types.absolute
    prop.offset = data.offset or model.get_offset()
    prop.center = position.get_normalized(data.target)
    prop.offx = prop.offset * math.sin(prop.orientation * 2 * math.pi) * -1
    prop.offy = prop.offset * math.cos(prop.orientation * 2 * math.pi)

    return prop
end

local calculate_prop = function(data)
    local prop
    if data.source then
        prop = calculate_relative(data)
    else
        prop = calculate_absolute(data)
    end

    -- Add generic info to prop
    local srf = data.surface or data.target.surface or data.source.surface -- TODO: data.surface should only be used if not data.source
    if type(srf) == "table" then
        prop.surface = srf
    else
        prop.surface = game.get_surface(srf)
    end
    prop.time_to_live = data.time_to_live or model.get_time_to_live()
    prop.scale = data.scale or model.get_scale()
    prop.sprite = get_valid_arrow_sprite(data.arrow_sprite)
    prop.color = data.arrow_color or model.get_arrow_color()

    if prop.type == const.types.relative_from_entity then
        prop.target = data.source
    elseif prop.type == const.types.relative_from_position then
        prop.target = position.get_normalized(data.source)
    else
        prop.target = position.get_normalized(data.target)
    end

    return prop
end

controller.create = function(data)
    -- Define how the arrow is to be created based on the parameters passed
    local prop = calculate_prop(data)

    local id, arrow_id, box_id = view.draw(prop)

    model.store(id, data, prop, arrow_id, box_id)

    return id
end

controller.remove = function(id)
    -- Get the data
    local v = model.get(id)
    if not v then
        -- Early exit if we tried to retrieve an ID that does not exist
        return false
    end

    view.destroy(v.arrow_id)
    view.destroy(v.box_id)
    model.remove(id)

    -- Get the model again and check if it returns nil or not
    -- If it is not nil then we did something wrong in model.remove(id)
    v = model.get(id)
    return v == nil
end

controller.remove_all = function()
    local success = true

    -- Get array of ids
    local ids = {}
    for k, v in pairs(model.get_all()) do
        table.insert(ids, k)
    end

    -- Loop through the keys and remove the actual data
    for _, id in pairs(ids) do
        success = success and controller.remove(id)
    end
    return success
end

controller.get_distance = function(id)
    local v = model.get(id)
    if not v then
        return
    end
    return v.prop.distance
end

controller.tick_update = function()
    for k, v in pairs(model.get_all()) do
        v.prop = calculate_prop(v.data)
        view.update(v)
    end
end

controller.init = function()
    -- Initialize global array
    if not global.arrowlib then
        global.arrowlib = {
            arrows = {},
            arrow_settings = {}
        }
    end
end

controller.set_data = function(data)
    -- Set global lib settings
    if not data then
        data = {}
    end
    local globset = global.arrowlib.arrow_settings
    globset.ARROW_SPRITE = (data.arrow_sprite or globset.ARROW_SPRITE or const.arrow.SPRITE)
    globset.ARROW_SPRITE_COLOR = (data.arrow_color or globset.ARROW_SPRITE_COLOR or const.arrow.SPRITE_COLOR)
    globset.ARROW_TIME_TO_LIVE = (data.time_to_live or globset.ARROW_TIME_TO_LIVE or const.arrow.TIME_TO_LIVE)
    globset.ARROW_OFFSET = (data.offset or globset.ARROW_OFFSET or const.arrow.OFFSET)
    globset.ARROW_SCALE = (data.scale or globset.ARROW_SCALE or const.arrow.SCALE)
    globset.ARROW_FORCES = (data.forces or globset.ARROW_FORCES or nil)
    globset.ARROW_PLAYERS = (data.players or globset.ARROW_PLAYERS or nil)
    globset.UPDATES_PER_TICK = (data.updates_per_tick or globset.UPDATES_PER_TICK or const.settings.UPDATES_PER_TICK)
    globset.RAISE_ERRORS = (data.raise_errors or globset.RAISE_ERRORS or const.settings.RAISE_ERRORS)
    globset.RAISE_WARNINGS = (data.raise_warnings or globset.RAISE_WARNINGS or const.settings.RAISE_WARNINGS)
end

return controller
