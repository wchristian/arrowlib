```lua
local function foo()
    --Get some variables to work with
    local player_one = game.players[1]
    local arrow_target = {0,0}
    local data = {
        source = player_one.character, -- Draw from the character
        target = arrow_target, -- Point to the world origin
        time_to_live = 30 -- Overrides this arrow's time to live for 30 seconds
    }

    --Draw the arrow and store the reference in global
    local id = arrow.create(data)
    global.foo.id = id
end
```

---

`create({...})` --> _string_ or false

Creates a new arrow

**Parameters**

(arguments which are striked through are not yet implemented)

| Argument                | Accepted values                                                                                       | Description                                                                                                     |
| ----------------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `source` ?              | position data\*                                                                                       | Center of the source where the arrow revolves around                                                            |
| `source_direction` ?    | orientation\*\*                                                                                       | Required and only used when `source` is not set, defaults to `from_top`                                         |
| `target`                | position data\*                                                                                       | Center of the target where the arrow is pointing to                                                             |
| `surface`?              | [SurfaceIdentification](https://lua-api.factorio.com/latest/concepts.html#SurfaceIdentification)      | The arrow's surface, required if both `source` and `target` are MapPosition                                     |
| `time_to_live` ?        | nil, 0 to 71 582 788                                                                                  | Overrides the time to live in seconds for this specific arrow                                                   |
| `offset` ?              | 1 to 50                                                                                               | Overrides the offset from source (or target when `source` is not set) in tiles for this specific arrow          |
| `scale` ?               | 1 to 25                                                                                               | Overrides the scaling for this specific arrow                                                                   |
| ~~`draw_target_box` ?~~ | bool                                                                                                  | Overrides drawing a rectangle around this specific target                                                       |
| ~~`forces` ?~~          | array[[ForceIdentification](https://lua-api.factorio.com/latest/concepts.html#ForceIdentification)]   | Overrides forces that this arrow is rendered to, passing `nil` or an empty table will render it to all forces   |
| ~~`players` ?~~         | array[[PlayerIdentification](https://lua-api.factorio.com/latest/concepts.html#PlayerIdentification)] | Overrides players that this arrow is rendered to, passing `nil` or an empty table will render it to all players |
| ~~`render_tag_icon`~~   | Bool                                                                                                  | Render the tag icon on the world when pointing from/to a chart tag, defaults to `false`                         |

\*) Position data = union{[LuaEntity](https://lua-api.factorio.com/latest/classes/LuaEntity.html), [LuaCustomChartTag](https://lua-api.factorio.com/latest/classes/LuaCustomChartTag.html), [LuaTile](https://lua-api.factorio.com/latest/classes/LuaTile.html), [BoundingBox](https://lua-api.factorio.com/latest/concepts.html#BoundingBox) [MapPosition](https://lua-api.factorio.com/latest/concepts.html#MapPosition)}

\*\*) orientation = union{`arrow.defines.source_direction.from_top`, `arrow.defines.source_direction.from_left`, `arrow.defines.source_direction.from_bottom`, `arrow.defines.source_direction.from_right`}
