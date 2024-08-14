local const = {
    settings = { -- Global mod settings
        UPDATES_PER_TICK = 50,
        RAISE_ERRORS = true,
        RAISE_WARNINGS = false
    },
    arrow = { -- Arrow specific settings
        TIME_TO_LIVE = 0,
        OFFSET = 5,
        SCALE = 2,
        SPRITE = "better-solid-outline",
        SPRITE_COLOR = {255, 159, 27},
        disallow_coloring = {"default", "navigation"}
    },
    defines = {
        source_direction = {
            from_top = 1,
            from_left = 2,
            from_bottom = 3,
            from_right = 4
        },
        arrow = {
            better_solid_fill = "better-solid-fill",
            better_solid_outline = "better-solid-outline",
            better_transparent_outline = "better-transparent-outline",
            block_solid_fill = "block-solid-fill",
            block_solid_outline = "block-solid-outline",
            block_transparent_outline = "block-transparent-outline",
            bracket_double = "bracket-double",
            bracket_single = "bracket-single",
            cursor_solid_fill = "cursor-solid-fill",
            cursor_solid_outline = "cursor-solid-outline",
            cursor_transparent_outline = "cursor-transparent-outline",
            default = "default",
            hand_solid_fill = "hand-solid-fill",
            hand_solid_outline = "hand-solid-outline",
            hand_transparent_outline = "hand-transparent-outline",
            navigation = "navigation"
        },
        color = {
            red = {255, 0, 0},
            green = {0, 255, 0},
            blue = {0, 0, 255},
            orange = {255, 159, 27},
            white = {255, 255, 255},
            black = {0, 0, 0},
            yellow = {255, 255, 0},
            purple = {255, 0, 255},
            teal = {0, 255, 255}
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
