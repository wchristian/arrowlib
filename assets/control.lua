-- Simple wrapper around test.lua which can be called from any mods control.lua
local arrow = require("__arrowlib__/arrow")
local test = require("__arrowlib__/test")

local function create_command(name, description, callback)
    local comm = commands.commands
    -- Add debug commands
    if not comm[name] then
        commands.add_command(name, description, callback)
    end
end

local function init_arrow()
    -- Init arrow class
    local data = {
        raise_warnings = true
    }
    -- arrow.init(data)
    arrow.init()
    -- Generate commands
    create_command("arrowlib_run_tests", "Run arrow library tests", function(command)
        test.run_all(arrow, false)
    end)
    create_command("arrowlib_run_tests_persistent", "Run arrow library tests", function(command)
        test.run_all(arrow, true)
    end)
    create_command("arrowlib_clear", "Run arrow library tests", function(command)
        test.clear_all(arrow)
    end)
end

script.on_configuration_changed(function()
    init_arrow()
end)

script.on_init(function()
    init_arrow()
end)
