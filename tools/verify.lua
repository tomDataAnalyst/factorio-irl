-- Checks on the final data.raw produced by tools/data_harness.lua.
--   1. reference checks (the kind of errors that stop Factorio loading)
--   2. reachability from an empty start (plan Phase 4 / 6)
-- Returns a report string; "FAIL" lines are problems.

local raw, MOD = ...
local out = {}
local function say(s) out[#out + 1] = s end
local fails = 0
local function fail(s) fails = fails + 1; say("FAIL " .. s) end

local ITEM_TYPES = { "item", "tool", "ammo", "capsule", "module", "gun", "armor", "repair-tool", "item-with-entity-data",
  "rail-planner", "space-platform-starter-pack", "item-with-inventory", "item-with-label", "item-with-tags",
  "selection-tool", "blueprint", "blueprint-book", "deconstruction-item", "upgrade-item", "copy-paste-tool", "spidertron-remote" }
local item = {}
for _, t in pairs(ITEM_TYPES) do for n, p in pairs(raw[t] or {}) do item[n] = p end end
local fluid = raw.fluid or {}
local function exists(kind, name)
  if kind == "fluid" then return fluid[name] ~= nil end
  return item[name] ~= nil
end

local ENTITY_TYPES = {}
for t, list in pairs(raw) do
  for _, p in pairs(list) do
    if type(p) == "table" and (p.collision_box or p.selection_box or t == "resource" or t == "tree" or t == "simple-entity") then
      ENTITY_TYPES[t] = true
    end
    break
  end
end
local entity = {}
for t in pairs(ENTITY_TYPES) do for n, p in pairs(raw[t]) do entity[n] = p end end

---------------------------------------------------------------- 1. references
for n, r in pairs(raw.recipe) do
  if r.category ~= nil then fail("recipe " .. n .. " uses removed field `category`") end
  for _, c in pairs(r.categories or {}) do
    if not raw["recipe-category"][c] then fail("recipe " .. n .. " category " .. c .. " missing") end
  end
  for _, i in pairs(r.ingredients or {}) do
    if not exists(i.type, i.name) then fail("recipe " .. n .. " ingredient " .. tostring(i.name) .. " missing") end
    if i.probability then fail("recipe " .. n .. " ingredient uses probability") end
  end
  for _, p in pairs(r.results or {}) do
    if not exists(p.type, p.name) then fail("recipe " .. n .. " result " .. tostring(p.name) .. " missing") end
    if p.probability then fail("recipe " .. n .. " result uses removed field `probability`") end
  end
end
for n, p in pairs(item) do
  if p.subgroup and not raw["item-subgroup"][p.subgroup] then fail("item " .. n .. " subgroup " .. p.subgroup .. " missing") end
  if p.place_result and not entity[p.place_result] then fail("item " .. n .. " place_result " .. p.place_result .. " missing") end
  if p.fuel_category then fail("item " .. n .. " uses removed field `fuel_category`") end
  for _, c in pairs(p.fuel_categories or {}) do
    if not raw["fuel-category"][c] then fail("item " .. n .. " fuel category " .. c .. " missing") end
  end
end
for n, sg in pairs(raw["item-subgroup"]) do
  if not raw["item-group"][sg.group] then fail("subgroup " .. n .. " group " .. tostring(sg.group) .. " missing") end
end
for n, e in pairs(entity) do
  for _, c in pairs(e.crafting_categories or {}) do
    if not raw["recipe-category"][c] then fail("entity " .. n .. " crafting category " .. c .. " missing") end
  end
  local es = e.energy_source
  if type(es) == "table" and es.type == "burner" then
    if es.fuel_category then fail("entity " .. n .. " burner uses removed `fuel_category`") end
    for _, c in pairs(es.fuel_categories or {}) do
      if not raw["fuel-category"][c] then fail("entity " .. n .. " fuel category " .. c .. " missing") end
    end
  end
  local m = e.minable
  if type(m) == "table" then
    if m.result and not item[m.result] then fail("entity " .. n .. " mines into missing " .. m.result) end
    for _, r in pairs(m.results or {}) do
      if not exists(r.type, r.name) then fail("entity " .. n .. " mines into missing " .. tostring(r.name)) end
    end
  end
  if e.next_upgrade and not entity[e.next_upgrade] then fail("entity " .. n .. " next_upgrade missing") end
end
-- burners whose starting fuel doesn't fit their fuel categories fail to load
local function check_burners(where, t, seen)
  if type(t) ~= "table" or seen[t] then return end
  seen[t] = true
  if rawget(t, "type") == "burner" and rawget(t, "initial_fuel") then
    local f = item[t.initial_fuel]
    local ok = false
    for _, a in pairs(f and f.fuel_categories or {}) do
      for _, b in pairs(t.fuel_categories or { "chemical" }) do if a == b then ok = true end end
    end
    if not ok then fail(where .. " initial_fuel " .. t.initial_fuel .. " does not fit its fuel categories") end
  end
  for _, v in pairs(t) do check_burners(where, v, seen) end
end
-- furnaces pick recipes from their input, so every recipe they can run needs one item ingredient
for n, f in pairs(raw.furnace or {}) do
  local fc = {}
  for _, c in pairs(f.crafting_categories or {}) do fc[c] = true end
  for rn, r in pairs(raw.recipe) do
    local hit = false
    for _, c in pairs(r.categories or { "crafting" }) do if fc[c] then hit = true end end
    if hit then
      local items, fluids = 0, 0
      for _, i in pairs(r.ingredients or {}) do if i.type == "fluid" then fluids = fluids + 1 else items = items + 1 end end
      if items > 1 or (fluids > 0 and not f.fluid_boxes) then fail("furnace " .. n .. " category recipe " .. rn .. " has " .. items .. " items/" .. fluids .. " fluids") end
    end
  end
end
for ty, list in pairs(raw) do for n, p in pairs(list) do check_burners(ty .. "/" .. n, p, {}) end end
for n, t in pairs(raw.technology) do
  for _, p in pairs(t.prerequisites or {}) do
    if not raw.technology[p] then fail("tech " .. n .. " prerequisite " .. p .. " missing") end
  end
  for _, e in pairs(t.effects or {}) do
    if e.type == "unlock-recipe" or e.type == "unlock-quality" or e.type == "give-item" then
      fail("tech " .. n .. " still has " .. e.type)
    end
    if e.recipe and not raw.recipe[e.recipe] then fail("tech " .. n .. " effect recipe " .. e.recipe .. " missing") end
  end
  for _, i in pairs(t.unit and t.unit.ingredients or {}) do
    if not item[i[1] or i.name] then fail("tech " .. n .. " pack " .. tostring(i[1]) .. " missing") end
  end
end
-- any `technology = "..."` reference anywhere (tips, achievements, triggers)
local function walk_tech_refs(where, t, seen)
  if type(t) ~= "table" or seen[t] then return end
  seen[t] = true
  if type(rawget(t, "technology")) == "string" and not raw.technology[t.technology] then
    fail(where .. " references missing technology " .. t.technology)
  end
  for _, v in pairs(t) do walk_tech_refs(where, v, seen) end
end
for ty, list in pairs(raw) do
  if ty ~= "technology" then
    for n, p in pairs(list) do walk_tech_refs(ty .. "/" .. n, p, {}) end
  end
end
for pn, planet in pairs(raw.planet or {}) do
  local mgs = planet.map_gen_settings
  if mgs then
    for c in pairs(mgs.autoplace_controls or {}) do
      if not raw["autoplace-control"][c] then fail("planet " .. pn .. " control " .. c .. " missing") end
    end
    local ent = mgs.autoplace_settings and mgs.autoplace_settings.entity
    for en in pairs(ent and ent.settings or {}) do
      if not entity[en] then fail("planet " .. pn .. " autoplaces missing entity " .. en)
      elseif not entity[en].autoplace then fail("planet " .. pn .. " autoplaces " .. en .. " which has no autoplace") end
    end
  end
end
for _, c in pairs(raw.character.character.crafting_categories) do
  if c ~= "hand" then fail("character can craft category " .. c) end
end
local recipes_disabled = 0
for n, r in pairs(raw.recipe) do if r.enabled == false then recipes_disabled = recipes_disabled + 1 end end
say("recipes: " .. (function() local k = 0 for _ in pairs(raw.recipe) do k = k + 1 end return k end)() ..
    ", disabled: " .. recipes_disabled .. ", techs left: " ..
    (function() local k = 0 for _ in pairs(raw.technology) do k = k + 1 end return k end)())

---------------------------------------------------------------- era order
-- A recipe may only use ingredients from its own era or earlier.
do
  local eras = dofile(MOD .. "/data/master/eras.lua")
  local rank = {}
  for i, e in ipairs(eras) do rank[e.name] = i end
  local era_of = {}
  for _, it in ipairs(dofile(MOD .. "/data/master/items.lua")) do era_of[it.name] = it.era end
  local fluids_ok = { water = true, ["sulfuric-acid"] = true, steam = true }
  for _, r in ipairs(dofile(MOD .. "/data/master/recipes.lua")) do
    for _, i in ipairs(r.ingredients) do
      local e = era_of[i[1]] or (i.fluid and fluids_ok[i[1]] and "industrial") or "modern"
      if rank[e] > rank[r.era] then
        fail("era order: " .. r.name .. " (" .. r.era .. ") uses " .. i[1] .. " (" .. e .. ")")
      end
    end
  end
end

---------------------------------------------------------------- 2. reachability
local have = {}           -- item/fluid name -> true
local cats = { hand = true }
local placed = {}         -- entity names we can build
local mining_cats = { ["basic-solid"] = true }   -- by hand
local order = {}

local function gain(name)
  if not have[name] then have[name] = true; order[#order + 1] = name; return true end
end

-- What can a buildable entity do for us?
local function enable_entity(en)
  if placed[en] then return false end
  placed[en] = true
  local e = entity[en]
  if not e then return false end
  for _, c in pairs(e.crafting_categories or {}) do cats[c] = true end
  for _, c in pairs(e.resource_categories or {}) do mining_cats[c] = true end
  return true
end

local planets_open = false
local function world_sources()
  local changed = false
  -- resources: Nauvis always; other planets once rocket + platform exist
  local nauvis = raw.planet.nauvis.map_gen_settings.autoplace_settings.entity.settings
  for pn, planet in pairs(raw.planet) do
    if pn == "nauvis" or planets_open then
      local ent = planet.map_gen_settings and planet.map_gen_settings.autoplace_settings
        and planet.map_gen_settings.autoplace_settings.entity
      for en in pairs(ent and ent.settings or {}) do
        local e = entity[en]
        local cat = e and (e.category or "basic-solid")
        local ok = e and (e.type ~= "resource" or mining_cats[cat])
        if ok and e.minable then
          if e.minable.result and gain(e.minable.result) then changed = true end
          for _, r in pairs(e.minable.results or {}) do if gain(r.name) then changed = true end end
        end
      end
      -- offshore pump fluids from this planet's tiles
      if placed["offshore-pump"] then
        local tiles = planet.map_gen_settings and planet.map_gen_settings.autoplace_settings
          and planet.map_gen_settings.autoplace_settings.tile
        for tn in pairs(tiles and tiles.settings or {}) do
          local tile = raw.tile[tn]
          if tile and tile.fluid and gain(tile.fluid) then changed = true end
        end
      end
    end
  end
  -- our scripted pickables (by planet)
  for _, r in ipairs(dofile(MOD .. "/data/master/resources.lua")) do
    if r.method == "pickable" and ((r.planet or "nauvis") == "nauvis" or planets_open) then
      local e = raw["simple-entity"][r.name] or raw.tree[r.name]
      for _, x in pairs(e and e.minable and e.minable.results or {}) do if gain(x.name) then changed = true end end
    end
  end
  for en, e in pairs(raw.tree) do
    if not raw.plant or not raw.plant[en] then
      local m = e.minable
      if m then
        if m.result and gain(m.result) then changed = true end
        for _, r in pairs(m.results or {}) do if gain(r.name) then changed = true end end
      end
    end
  end
  if planets_open then
    for _, p in pairs(raw.plant or {}) do
      for _, r in pairs(p.minable and p.minable.results or {}) do if gain(r.name) then changed = true end end
    end
    for _, a in pairs(raw["asteroid-chunk"] or {}) do
      for _, r in pairs(a.minable and a.minable.results or {}) do if gain(r.name) then changed = true end end
      if a.minable and a.minable.result and gain(a.minable.result) then changed = true end
    end
  end
  -- spoil and burnt results
  for n in pairs(have) do
    local p = item[n]
    if p then
      if p.spoil_result and gain(p.spoil_result) then changed = true end
      if p.burnt_result and gain(p.burnt_result) then changed = true end
    end
  end
  return changed
end

local function recipe_ok(r)
  if r.hidden and not (r.categories and r.categories[1] == "recycling") then
    -- hidden recipes still count if a machine can run them (e.g. excavation, recycling)
  end
  local any = false
  for _, c in pairs(r.categories or { "crafting" }) do if cats[c] then any = true end end
  if not any then return false end
  for _, i in pairs(r.ingredients or {}) do if not have[i.name] then return false end end
  return true
end

local function boilers()
  local c = false
  for en in pairs(placed) do
    local e = entity[en]
    if e and e.type == "boiler" and have["water"] and gain("steam") then c = true end
  end
  return c
end

local changed = true
while changed do
  if boilers() then changed = true end
  changed = world_sources()
  for _, r in pairs(raw.recipe) do
    if r.enabled ~= false and (r.categories or {})[1] ~= "parameters" and recipe_ok(r) then
      for _, p in pairs(r.results or {}) do
        if gain(p.name) then changed = true end
      end
    end
  end
  for n in pairs(have) do
    local p = item[n]
    if p and p.place_result and enable_entity(p.place_result) then changed = true end
  end
  if not planets_open and have["rocket-part"] and have["space-platform-starter-pack"] and placed["rocket-silo"] then
    planets_open = true; changed = true
    say("planets open after " .. #order .. " items/fluids")
  end
end

local missing = {}
for n, r in pairs(raw.recipe) do
  if r.enabled ~= false and not r.hidden and (r.categories or {})[1] ~= "parameters" then
    for _, p in pairs(r.results or {}) do
      if not have[p.name] then missing[p.name] = n end
    end
  end
end
local names = {}
for n in pairs(missing) do names[#names + 1] = n end
table.sort(names)
for _, n in ipairs(names) do fail("unreachable: " .. n .. " (recipe " .. missing[n] .. ")") end
-- Explain the first blocker for a few key items.
local function explain(name, depth, seen)
  seen = seen or {}
  if have[name] or seen[name] or depth > 12 then return end
  seen[name] = true
  local best
  for rn, r in pairs(raw.recipe) do
    for _, p in pairs(r.results or {}) do if p.name == name then best = best or r end end
  end
  if not best then say(string.rep("  ", depth) .. name .. ": no recipe produces it"); return end
  local catok = false
  for _, c in pairs(best.categories or { "crafting" }) do if cats[c] then catok = true end end
  local miss = {}
  for _, i in pairs(best.ingredients or {}) do if not have[i.name] then miss[#miss + 1] = i.name end end
  say(string.rep("  ", depth) .. name .. " <- " .. best.name .. (catok and "" or (" [no station: " .. table.concat(best.categories or {}, ",") .. "]")) ..
      (#miss > 0 and (" missing: " .. table.concat(miss, ", ")) or ""))
  for _, m in ipairs(miss) do explain(m, depth + 1, seen) end
end
for _, k in pairs({ "rocket-part", "rocket-silo", "space-platform-starter-pack", "uranium-238" }) do explain(k, 0) end
-- every station buildable, every milestone completable
for _, st in pairs(dofile(MOD .. "/data/master/stations.lua").stations) do
  if not have[st.name] then fail("station item never obtainable: " .. st.name) end
end
local ms = dofile(MOD .. "/data/master/milestones.lua")
local ids = {}
for _, m in ipairs(ms) do ids[m.id] = true end
for _, m in ipairs(ms) do
  for _, q in ipairs(m.requires) do if not ids[q] then fail("milestone " .. m.id .. " requires unknown " .. q) end end
  local target = m.done[2]
  if m.done[1] == "entity-built" then
    if not entity[target] then fail("milestone " .. m.id .. " entity " .. target .. " missing")
    elseif not placed[target] then fail("milestone " .. m.id .. " entity " .. target .. " never buildable") end
  elseif not have[target] then fail("milestone " .. m.id .. " item " .. target .. " never obtainable") end
end
for _, l in pairs(LOGS or {}) do if l:find("factorio%-irl") then fail("mod log: " .. l) end end
say("reachable items/fluids: " .. #order)
say(fails == 0 and "ALL CHECKS PASSED" or (fails .. " problems"))
return table.concat(out, "\n")
