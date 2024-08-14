local const = require("__arrowlib__/lib/const")

local test = {}

local function from_player_to_world_origin(arrow, persistent, character)
    -- Create the arrow
    local pos = {0, 0}
    local data = {
        source = character,
        target = pos,
        offset = 1
    }
    local result = arrow.create(data)

    -- Check if an arrow was succesfully created
    assert(result)

    if not persistent then
        -- Remove the arrow
        local removed = arrow.remove(result)

        -- Check if an arrow was succesfully removed
        assert(removed)
    end

    game.print("Test " .. debug.getinfo(1, "n").name .. " passed")
end

local function from_world_origin_to_player(arrow, persistent, character)
    -- Create the arrow
    local pos = {0, 0}
    local data = {
        source = pos,
        target = character
    }
    local result = arrow.create(data)

    -- Check if an arrow was succesfully created
    assert(result)

    if not persistent then
        -- Remove the arrow
        local removed = arrow.remove(result)

        -- Check if an arrow was succesfully removed
        assert(removed)
    end

    game.print("Test " .. debug.getinfo(1, "n").name .. " passed")
end

local function absolute_to_world_origin(arrow, persistent)
    for _, dir in pairs(const.defines.source_direction) do
        local pos = {0, 0}
        local data = {
            source_direction = dir,
            target = pos,
            surface = 1,
            offset = 2
        }
        local result = arrow.create(data)

        -- Check if an arrow was succesfully created
        assert(result)

        if not persistent then
            -- Remove the arrow
            local removed = arrow.remove(result)

            -- Check if an arrow was succesfully removed
            assert(removed)
        end
    end

    game.print("Test " .. debug.getinfo(1, "n").name .. " passed")
end

local function all_sprites_lined_up_absolute(arrow, persistent)
    local x = 1
    for _, arr in pairs(const.defines.arrow) do
        local y = 1
        for _, col in pairs(const.defines.color) do
            local pos = {x * 2, y * 2}
            local data = {
                sprite = arr,
                arrow_color = col,
                source_direction = const.defines.source_direction.from_bottom,
                target = pos,
                surface = 1,
                offset = 1
            }
            local result = arrow.create(data)

            -- Check if an arrow was succesfully created
            assert(result)

            if not persistent then
                -- Remove the arrow
                local removed = arrow.remove(result)

                -- Check if an arrow was succesfully removed
                assert(removed)
            end
            y = y + 1
        end

        x = x + 1
    end

    game.print("Test " .. debug.getinfo(1, "n").name .. " passed")
end

local function get_character()
    -- Get any player character
    local player
    local character
    for _, p in pairs(game.players) do
        -- Try to get the character via player.character
        if p.character and p.character.valid then
            player = p
            character = p.character
            break
        end
        -- Try to get the character via player.associated_characters
        for _, c in pairs(p.get_associated_characters()) do
            if c.valid then
                player = p
                character = c
                break
            end
        end
    end

    return character
end

test.run_all = function(arrow, persistent)
    -- Set the variables
    if not persistent then
        persistent = false
    end
    local character = get_character()

    -- Start the tests
    game.print("=== Starting tests ===")
    if persistent then
        game.print("(persistent)")
    end

    -- Tests with character
    if character then
        -- Only run if we found a character
        from_player_to_world_origin(arrow, persistent, character)
        from_world_origin_to_player(arrow, persistent, character)
    end

    -- Tests without character
    absolute_to_world_origin(arrow, persistent)
    all_sprites_lined_up_absolute(arrow, persistent)

    -- Tests finished
    game.print("=== Tests complete ===")
end

test.clear_all = function(arrow)
    arrow.remove_all()
    game.print("Removed all remaining arrows")
end

return test
