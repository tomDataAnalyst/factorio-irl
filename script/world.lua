-- Phase 3 runtime: pickable placement, regrowth (Tom, Q11), excavator recipe by tile.

local R = require("data.master.resources")

local W = {}

local pickables, excavate_by_tile = {}, {}
local is_pickable = {}
for _, r in ipairs(R) do
  if r.method == "pickable" then pickables[#pickables + 1] = r; is_pickable[r.name] = r end
  if r.method == "excavator" then
    for _, t in pairs(r.tiles) do excavate_by_tile[t] = r.name end
  end
end
local REGROW_PICKABLE = R.regrow_minutes.pickable * 3600
local REGROW_TREE = R.regrow_minutes.tree * 3600
local WATER = { "water", "deepwater", "water-green", "deepwater-green", "water-shallow", "water-mud" }

local function on_home_planet(surface) return surface.name == "nauvis" end

local function rand_in(area)
  return { x = area.left_top.x + math.random() * 32, y = area.left_top.y + math.random() * 32 }
end

local function near(pos, r)
  return { x = pos.x + (math.random() * 2 - 1) * r, y = pos.y + (math.random() * 2 - 1) * r }
end

local function try_place(surface, name, pos)
  if surface.can_place_entity({ name = name, position = pos }) then
    return surface.create_entity({ name = name, position = pos }) ~= nil
  end
  return false
end

---------------------------------------------------------------- placement
function W.populate_chunk(surface, area)
  if not on_home_planet(surface) then return end
  local water_tiles, trees, ores = nil, nil, {}
  for _, p in pairs(pickables) do
    local s = p.spawn
    for _ = 1, s.per_chunk do
      local pos
      if s.near == "water" then
        water_tiles = water_tiles or surface.find_tiles_filtered({ area = area, name = WATER, limit = 64 })
        if #water_tiles > 0 then pos = near(water_tiles[math.random(#water_tiles)].position, 3) end
      elseif s.near == "trees" then
        trees = trees or surface.find_entities_filtered({ area = area, type = "tree", limit = 64 })
        if #trees > 0 then pos = near(trees[math.random(#trees)].position, 2) end
      elseif s.near and s.near:sub(1, 4) == "ore:" then
        local ore = s.near:sub(5)
        ores[ore] = ores[ore] or surface.find_entities_filtered({ area = area, name = ore, limit = 64 })
        local list = ores[ore]
        if #list > 0 then pos = near(list[math.random(#list)].position, 4) end
      else
        pos = rand_in(area)
      end
      if pos and s.tiles then
        local tile = surface.get_tile(pos.x, pos.y)
        if not (tile.valid and tile.name:sub(1, #s.tiles) == s.tiles) then pos = nil end
      end
      if pos then try_place(surface, p.name, pos) end
    end
  end
end

-- Adding the mod to an existing save: fill the chunks already generated.
function W.populate_existing()
  storage.irl_world = storage.irl_world or {}
  if storage.irl_world.populated then return end
  storage.irl_world.populated = true
  local surface = game.surfaces["nauvis"]
  if not surface then return end
  for chunk in surface.get_chunks() do
    if surface.is_chunk_generated(chunk) then W.populate_chunk(surface, chunk.area) end
  end
end

function W.init_new_game()
  storage.irl_world = storage.irl_world or {}
  storage.irl_world.populated = true   -- chunks will be filled as they generate
  storage.irl_world.regrow = storage.irl_world.regrow or {}
end

---------------------------------------------------------------- regrowth
local function queue()
  storage.irl_world = storage.irl_world or {}
  storage.irl_world.regrow = storage.irl_world.regrow or {}
  return storage.irl_world.regrow
end

function W.on_mined(entity)
  if not (entity and entity.valid) or not on_home_planet(entity.surface) then return end
  local delay
  if is_pickable[entity.name] then delay = REGROW_PICKABLE
  elseif entity.type == "tree" then delay = REGROW_TREE
  else return end
  local q = queue()
  if #q >= 50000 then return end
  q[#q + 1] = { s = entity.surface.index, n = entity.name, x = entity.position.x, y = entity.position.y,
                t = game.tick + delay, tries = 0 }
end

function W.process_regrowth()
  local q = queue()
  local now = game.tick
  local i = 1
  while i <= #q do
    local e = q[i]
    local done = false
    if e.t <= now then
      local surface = game.surfaces[e.s]
      if not surface or try_place(surface, e.n, { x = e.x, y = e.y }) or e.tries >= 3 then
        done = true
      else
        e.tries = e.tries + 1
        e.t = now + 5 * 3600   -- something is in the way; try again later
      end
    end
    if done then q[i] = q[#q]; q[#q] = nil else i = i + 1 end
  end
end

---------------------------------------------------------------- excavator
function W.set_excavator_recipe(entity, player)
  if not (entity and entity.valid and entity.name == "excavator") then return end
  local tile = entity.surface.get_tile(entity.position.x, entity.position.y)
  local recipe = tile.valid and excavate_by_tile[tile.name]
  if recipe then
    local current = entity.get_recipe()
    if not current or current.name ~= recipe then entity.set_recipe(recipe) end
  else
    entity.set_recipe(nil)
    if player then
      player.create_local_flying_text({ text = "Nothing to dig here", position = entity.position })
    end
  end
end

return W
