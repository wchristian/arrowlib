-- This is where we keep track of all the arrows and the data under them
local model = {}

model.update_settings = function(data)
end

model.get_offset = function()
    return global.arrowlib.arrow_settings.ARROW_OFFSET
end

model.get_time_to_live = function()
    return global.arrowlib.arrow_settings.ARROW_TIME_TO_LIVE
end

model.get_scale = function()
    return global.arrowlib.arrow_settings.ARROW_SCALE
end

-- local validate = function(p, gp)
--     -- Early exit if we do not have a character
--     if not p.character then
--         return
--     end

--     -- Initiate scan array
--     if not gp.scan then
--         gp.scan = {}
--     end
--     if not gp.scan.to_track then
--         gp.scan.to_track = {}
--     end
--     if not gp.to_track then
--         gp.to_track = {}
--     end

--     -- Spaced update
--     local action = 1

--     while action < 100 do
--         -- Get entity to track index
--         local idx = gp.scan.track_entity_idx or 1
--         if idx > #gp.track_entities then
--             -- All entities analyzed, copy over scan to gp
--             -- for id, prop in pairs(gp.scan.to_track) do
--             --     gp.to_track[id] = prop
--             -- end
--             gp.to_track = gp.scan.to_track

--             -- Clear scan.to_track array
--             gp.scan.to_track = {}

--             -- Reset index counters
--             gp.scan.track_entity_idx = 1
--         else
--             -- Continue scanning
--             local e = gp.track_entities[idx]
--             if e.valid then
--                 local prop = calculate(p.character, e)
--                 local id = ""
--                 local draw_arrow = false
--                 local draw_box = false
--                 -- Distance based
--                 if prop.distance < 100 then
--                     -- Make ID based on entity position
--                     local pos = e.position
--                     id = "entity-x" .. pos.x .. "-y" .. pos.y -- The entity ID
--                     if prop.distance >= 5 then
--                         -- Draw arrow only when further than 5m
--                         draw_arrow = true
--                     else
--                     end
--                     -- Draw box always
--                     draw_box = true
--                 else
--                     -- Make ID based on angle segment
--                     id = "angle-seg" .. prop.angle_deg_seg -- The entity ID
--                     draw_arrow = true
--                 end

--                 gp.scan.to_track[id] = {
--                     id = id,
--                     entity = e,
--                     prop = prop,
--                     draw_arrow = draw_arrow,
--                     draw_box = draw_box,
--                     last_update = game.tick
--                 }
--             end
--             -- Increase scan index
--             gp.scan.track_entity_idx = idx + 1
--         end

--         -- Increase action counter
--         action = action + 1
--     end

-- end

-- local draw = function(p, gp)

--     -- Early exit if there is nothing to draw
--     if not gp.to_track then
--         return
--     end

--     -- Initiate render array
--     if not gp.drew then
--         gp.drew = {}
--     end
--     if not gp.to_track_indexes then
--         gp.to_track_indexes = {} -- Index translation array 
--     end

--     -- Get some variables to work with
--     local threshold = gp.track_start + (settings.global["gh_arrow-time-to-live"].value * 60)

--     -- Remove sprites which are no longer required
--     -- Iterate over drew sprites
--     for eid, arr in pairs(gp.drew) do
--         -- Check if we need to track this entity id
--         if not gp.to_track[eid] then
--             remove_render(gp, eid)
--         end
--     end

--     -- Spaced update
--     local action = 1

--     while action < settings.global["gh_track-entities-per-tick"].value do
--         -- Get index
--         local idx = gp.draw_entity_idx or 1
--         if idx > #gp.to_track_indexes then
--             -- Repopulate track indexes
--             local i = 1
--             for id, _ in pairs(gp.to_track) do
--                 gp.to_track_indexes[i] = id
--                 i = i + 1
--             end

--             -- game.print(serpent.line(gp.to_track_indexes))

--             idx = 1
--         end
--         local id = gp.to_track_indexes[idx]
--         local data = gp.to_track[id]

--         -- Only if we have data
--         if data then
--             -- Check if this still needs to be tracked by tick
--             -- local threshold = game.tick - (settings.global["gh_arrow-time-to-live"].value * 60)
--             if data.last_update > threshold then
--                 gp.to_track[id] = nil
--             else
--                 -- Add/update sprites which are still to be tracked
--                 -- Check if the id is new
--                 local new = not gp.drew[id]
--                 if new then
--                     gp.drew[id] = {}
--                 end

--                 -- Update the data
--                 gp.drew[id].data = data

--                 -- Draw new sprites
--                 -- if new then
--                 -- Draw the new sprite
--                 if data.draw_arrow then
--                     draw_arrow(p, gp.drew[id])
--                     update_arrow(p, gp.drew[id])
--                 else
--                     remove_arrow(p, gp.drew[id])
--                 end

--             end
--         end

--         gp.draw_entity_idx = idx + 1
--         action = action + 1
--     end
-- end

model.store = function(id, data, prop, arrow_id, box_id)
    global.arrowlib.arrows[id] = {
        data = data,
        prop = prop,
        arrow_id = arrow_id,
        box_id = box_id
    }
end

model.remove = function(id)
    global.arrowlib.arrows[id] = nil
end

model.get = function(id)
    return global.arrowlib.arrows[id]
end

model.get_all = function()
    return global.arrowlib.arrows
end

return model
