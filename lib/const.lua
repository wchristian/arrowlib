local const = {
    settings = { -- Global mod settings
        UPDATES_PER_TICK = 50,
        RAISE_ERRORS = true,
        RAISE_WARNINGS = false
    },
    arrow = { -- Arrow specific settings
        TIME_TO_LIVE = 0,
        OFFSET = 5,
        SCALE = 2
    },
    defines = {
        source_direction = {
            from_top = 1,
            from_left = 2,
            from_bottom = 3,
            from_right = 4
        }
    },
    orientation = {0.5, 0.25, 0, 0.75}, -- Based on defines orientation ID
    -- orientation = {0, 0.75, 0.5, 0.25}, -- Based on defines orientation ID
    types = {
        absolute = 1,
        relative_from_entity = 2,
        relative_from_position = 3
    }
}

return const
