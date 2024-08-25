```lua
local function bar()
    -- OPTION 1: Remove individual arrows
    local success = arrow.remove(global.foo.id)

    -- OPTION 2: Remove all arrows
    local success = arrow.remove_all()
end
```

---

`remove(id)` --> _bool_

Removes an existing arrow.

**Parameters**

| Argument | Accepted values | Description                  |
| -------- | --------------- | ---------------------------- |
| `id`     | string          | The ID of any existing arrow |

---

`remove_all()` --> _bool_

Removes all existing arrows.
