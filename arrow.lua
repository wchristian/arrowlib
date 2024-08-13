-- The main class instance with external interfaces which is imported as library
local const = require("__arrowlib__/lib/const")
local position = require("__arrowlib__/lib/position")

local controller = require("__arrowlib__/scripts/controller")

local arrow = {}

arrow.defines = const.defines

------------------------------------------------------------------------------------------
-- Error/warning/logging helpers
------------------------------------------------------------------------------------------

--- @param msg string
local log_trace = function(msg)
    log(msg)
    log(debug.traceback())
end

--- @param msg string
local error_if = function(msg)
    -- Write to log files
    log_trace(msg)

    -- Throw in game error if set
    if global.arrowlib.arrow_settings.RAISE_ERRORS then
        error(msg)
    end
end

--- @param msg string
local warning_if = function(msg)
    -- Write to log files
    log_trace(msg)

    -- Throw in game error if set
    if global.arrowlib.arrow_settings.RAISE_WARNINGS then
        error(msg)
    end
end

------------------------------------------------------------------------------------------
-- Interfaces
------------------------------------------------------------------------------------------

--- Creates an arrow according to the passed data table
--- @param data table The input arguments to create this arrow
--- @return string? id The ID of the generated arrow, or 'nil' when the input data is invalid
arrow.create = function(data)

    -- Validate data table - raises error
    if not data.source and not data.source_direction then

        error_if("Missing parameter: `source` or `source_direction`")
        return
    end
    if not data.target then

        error_if("Missing parameter: `target`")
        return
    end
    if not data.surface and (not data.source or not data.source.surface) and
        (not data.target or not data.target.surface) then

        error_if("Missing parameter: `surface` is required when both `source` and `target` do not contain a surface")
        return
    end
    if data.source and not position.is_valid(data.source) then

        error_if("Parameter `source` does not contain a valid position")
        return
    end
    if not position.is_valid(data.target) then

        error_if("Parameter `target` does not contain a valid position")
        return
    end
    if not data.source and data.source_direction and data.source_direction ~= arrow.defines.source_direction.from_top and
        data.source_direction ~= arrow.defines.source_direction.from_left and data.source_direction ~=
        arrow.defines.source_direction.from_bottom and data.source_direction ~=
        arrow.defines.source_direction.from_right then

        error_if("Parameter `source_direction` does not contain a valid direction")
        return
    end

    -- Data integrity checks - raises warning
    if data.source and data.source.surface and data.target and data.target.surface and data.source.surface ~=
        data.target.surface then
        warning_if("Source and target are not on the same surface")
        return
    end

    -- Create the actual arrow
    -- This is where the controller takes over
    local id = controller.create(data)

    return id
end

arrow.remove = function(data)
    return controller.remove(data)
    -- TODO: Implement check if command is executed correctly
end

arrow.remove_all = function()
    return controller.remove_all()
    -- TODO: Implement check if command is executed correctly
end

arrow.tick_update = function()
    local action = 1

    controller.tick_update()
end

arrow.get_distance = function(id)
    if not id then
        warning_if("Key `id` missing")
        return
    end
    if not tostring("id") then
        warning_if("Key `id` expected string, got " .. type(id))
        return
    end
    return controller.get_distance(id)
end

arrow.init = function(data)
    -- Initialize global array
    if not global.arrowlib then
        global.arrowlib = {
            arrows = {},
            arrow_settings = {}
        }
    end

    -- Set global lib settings
    if not data then
        data = {}
    end
    local globset = global.arrowlib.arrow_settings
    globset.ARROW_TIME_TO_LIVE = (data.time_to_live or const.arrow.TIME_TO_LIVE)
    globset.ARROW_OFFSET = (data.offset or const.arrow.OFFSET)
    globset.ARROW_SCALE = (data.scale or const.arrow.SCALE)
    globset.ARROW_FORCES = (data.forces or nil)
    globset.ARROW_PLAYERS = (data.players or nil)
    globset.UPDATES_PER_TICK = (data.updates_per_tick or const.settings.UPDATES_PER_TICK)
    globset.RAISE_ERRORS = (data.raise_errors or const.settings.RAISE_ERRORS)
    globset.RAISE_WARNINGS = (data.raise_warnings or const.settings.RAISE_WARNINGS)

end

return arrow
