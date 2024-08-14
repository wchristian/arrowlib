-- Add arrow sprites
local path = "__arrowlib__/graphics/arrows/"

local function sprite(name, width, height)
    return {
        type = "sprite",
        name = name,
        filename = path .. name .. ".png",
        width = width,
        height = height,
        scale = 0.2
    }
end
data:extend({sprite("better-solid-fill", "96", "96"), sprite("better-solid-outline", "96", "96"),
             sprite("better-transparent-outline", "96", "96"), sprite("block-solid-fill", "82", "113"),
             sprite("block-solid-outline", "82", "113"), sprite("block-transparent-outline", "82", "113"),
             sprite("bracket-double", "103", "96"), sprite("bracket-single", "103", "59"),
             sprite("cursor-solid-fill", "61", "96"), sprite("cursor-solid-outline", "61", "96"),
             sprite("cursor-transparent-outline", "61", "96"), sprite("default", "42", "55"),
             sprite("hand-solid-fill", "78", "96"), sprite("hand-solid-outline", "78", "96"), -- TODO: scale hand sprite
             sprite("hand-transparent-outline", "78", "96"), sprite("navigation", "80", "96")})

