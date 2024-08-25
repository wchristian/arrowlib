```lua
local arrow = require("__arrowlib__/arrow")

script.on_init(function(e)
    --OPTION 1: Init without additional arguments
    arrow.init()

    --OPTION 2: Init with additional arguments
    local data = {
        time_to_live = 30, -- Override default arrow time to live to 30 seconds
    }
    arrow.init(data)
end)

script.on_event(defines.events.on_tick, function(e)
    arrow.tick_update()
end)

local function foo(data)
    arrow.update_settings(data)
end
```

---

`init({...})`

Initializes the arrow library, passing below arguments overwrite the default settings for every new arrow. Initialization is required to be done from the mod using the library since the library utilizes the mod's `global`

**Parameters**

(arguments which are striked through are not yet implemented)

| Argument                 | Default                | Accepted values                                                                                       | Description                                                                                           |
| ------------------------ | ---------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| `arrow_sprite` ?         | 'better_solid_outline' | _defines.arrow.\*_ or [SpritePath](https://lua-api.factorio.com/latest/concepts.html#SpritePath)      | The sprite to be used as arrow                                                                        |
| `arrow_color` ?          | _defines.color.orange_ | _defines.color.\*_ or [Color](https://lua-api.factorio.com/latest/concepts.html#Color)                | The color of the arrow                                                                                |
| `time_to_live` ?         | 0                      | nil, 0 to 71 582 788                                                                                  | Default time to live in seconds for newly created arrows                                              |
| `offset` ?               | 5                      | 1 to 50                                                                                               | Offset from source in tiles                                                                           |
| `scale` ?                | 2                      | 1 to 25                                                                                               | Relative scaling of the arrow graphic                                                                 |
| ~~`updates_per_tick`~~ ? | 50                     | 1 to 500                                                                                              | How many arrows per tick are to be updated                                                            |
| `raise_errors` ?         | true                   | bool                                                                                                  | Wether critical incorrect function calls should raise an error or continue                            |
| `raise_warnings` ?       | false                  | bool                                                                                                  | Wether non-destructive incorrect function calls should raise an error or continue                     |
| ~~`draw_target_box`~~ ?  | true                   | bool                                                                                                  | Draw a rectangle around the target                                                                    |
| ~~`forces`~~ ?           | nil                    | array[[ForceIdentification](https://lua-api.factorio.com/latest/concepts.html#ForceIdentification)]   | Forces that this arrow is rendered to, passing `nil` or an empty table will render it to all forces   |
| ~~`players`~~ ?          | nil                    | array[[PlayerIdentification](https://lua-api.factorio.com/latest/concepts.html#PlayerIdentification)] | Players that this arrow is rendered to, passing `nil` or an empty table will render it to all players |

---

`update_settings({...})`

Updates the default settings for new arrows.

**Parameters**

Same as `init({...})`

---

`tick_update()`

Updates the orientation and position of arrows, which is required to be done from the mod using the library since the library utilizes the mod's `global`
