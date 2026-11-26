-- data-final-fixes: rules applied to existing vanilla and Space Age prototypes.
--   plan 2.2  no living enemies
--   plan 2.3  every recipe enabled; research only for upgrades
--   plan 2.4  station-only crafting
--   plan 2.5  vanilla recipes reworked in place (same names)
--   plan 2.6  era menu groups
--   Tom Q4    planets reachable by rocket and platform alone
--   Tom Q5    no quality

local U = require("prototypes.util")
local items    = U.master("items")
local recipes  = U.master("recipes")
local st       = U.master("stations")
local research = U.master("research")
local eras     = U.master("eras")
local world    = U.master("resources")

local era_order = {}
for _, e in pairs(eras) do era_order[e.name] = e.order end

---------------------------------------------------------------------------
-- Fuel: wood and sticks are "biomass", too cool for metal smelting (open question 4)
---------------------------------------------------------------------------
for _, it in pairs(items) do
  if it.vanilla and it.fuel then
    local p = U.find_item(it.name)
    if p then
      p.fuel_categories = { it.fuel[2] }
      p.fuel_value = it.fuel[1] .. "MJ"
    end
  end
end

---------------------------------------------------------------------------
-- Menu: vanilla items move into their era; everything else lands in Modern
---------------------------------------------------------------------------
for i, it in ipairs(items) do
  if it.vanilla then
    local p = U.find_item(it.name)
    if p then
      p.subgroup = "irl-" .. it.era .. "-" .. it.group
      p.order = era_order[it.era] .. string.format("%04d", i)
    else
      log("[factorio-irl] items.lua lists missing vanilla item " .. it.name)
    end
  end
end
local moved_groups = { logistics = true, production = true, ["intermediate-products"] = true, combat = true, space = true }
for _, sg in pairs(data.raw["item-subgroup"]) do
  if moved_groups[sg.group] then sg.group = "irl-modern" end
end

---------------------------------------------------------------------------
-- Vanilla recipe rework (recipes.lua rows with vanilla = true)
---------------------------------------------------------------------------
for i, r in ipairs(recipes) do
  if r.vanilla then
    local p = data.raw.recipe[r.name]
    if not p then
      p = { type = "recipe", name = r.name }
      data:extend({ p })
      p = data.raw.recipe[r.name]
    end
    p.category = nil
    p.categories = table.deepcopy(r.stations)
    p.energy_required = r.time
    p.ingredients = U.expand(r.ingredients)
    p.results = U.expand(r.results or { { r.name, 1 } })
    if p.main_product then
      local keep = false
      for _, res in pairs(p.results) do if res.name == p.main_product then keep = true end end
      if not keep then p.main_product = nil end
    end
  end
end

---------------------------------------------------------------------------
-- Vanilla machines learn our categories so they can automate older recipes
---------------------------------------------------------------------------
for name, ext in pairs(st.vanilla_extend) do
  local e = U.find_entity(name)
  if e then
    if ext.categories then e.crafting_categories = table.deepcopy(ext.categories) end
    for _, c in pairs(ext.add or {}) do
      e.crafting_categories = e.crafting_categories or {}
      U.add_unique(e.crafting_categories, c)
    end
    if ext.fuel_add and e.energy_source and e.energy_source.type == "burner" then
      e.energy_source.fuel_categories = e.energy_source.fuel_categories or { "chemical" }
      for _, c in pairs(ext.fuel_add) do U.add_unique(e.energy_source.fuel_categories, c) end
    end
    if ext.energy and e.energy_source and e.energy_source.type == "burner" then
      e.energy_source.fuel_categories = table.deepcopy(ext.energy[2])
    end
  else
    log("[factorio-irl] vanilla_extend: no entity " .. name)
  end
end

---------------------------------------------------------------------------
-- Character: only true hand work (plan 2.4)
---------------------------------------------------------------------------
for _, c in pairs(data.raw.character) do
  c.crafting_categories = table.deepcopy(st.character_categories)
end

---------------------------------------------------------------------------
-- Quality removed (Tom, Q5). Space Age depends on the quality mod, so it stays
-- loaded; we hide quality modules and drop every unlock-quality effect below,
-- so nothing above normal quality can ever be unlocked. The recycler stays
-- (Fulgora needs it for scrap).
---------------------------------------------------------------------------
local quality_modules = { "quality-module", "quality-module-2", "quality-module-3" }
local hidden_recipe = {}
for _, n in pairs(quality_modules) do
  if data.raw.recipe[n] then data.raw.recipe[n].hidden = true; hidden_recipe[n] = true end
  if data.raw.module[n] then data.raw.module[n].hidden = true end
end

---------------------------------------------------------------------------
-- Every recipe enabled from the start (plan 2.3)
---------------------------------------------------------------------------
for name, r in pairs(data.raw.recipe) do
  r.enabled = not hidden_recipe[name]
end

---------------------------------------------------------------------------
-- Research becomes upgrades only (plan 2.3)
---------------------------------------------------------------------------
local DROP = { ["unlock-recipe"] = true, ["give-item"] = true, ["unlock-quality"] = true, ["nothing"] = true }
-- Non-recipe unlocks are moved to the hidden "irl-foundations" tech, researched at start.
local MOVE = {
  ["unlock-space-location"] = true, ["unlock-space-platforms"] = true,
  ["unlock-travel-to-space-platforms"] = true, ["mining-with-fluid"] = true,
  ["cliff-deconstruction-enabled"] = true, ["rail-planner-allow-elevated-rails"] = true,
  ["rail-support-on-deep-oil-ocean"] = true, ["create-ghost-on-entity-death"] = true,
  ["unlock-circuit-network"] = true, ["unlock-logistic-network"] = true,
  ["vehicle-logistics"] = true, ["character-logistic-requests"] = true,
}

local ours = { ["irl-foundations"] = true }
for _, t in pairs(research.technologies) do if not t.keep then ours[t.name] = true end end

local foundations = data.raw.technology["irl-foundations"]
local moved = {}
local deleted = {}

for name, tech in pairs(data.raw.technology) do
  if not ours[name] then
    local kept = {}
    for _, e in pairs(tech.effects or {}) do
      if MOVE[e.type] then
        local key = e.type .. ":" .. tostring(e.space_location or e.modifier)
        if not moved[key] then
          moved[key] = true
          foundations.effects[#foundations.effects + 1] = table.deepcopy(e)
        end
      elseif not DROP[e.type] then
        kept[#kept + 1] = e
      end
    end
    tech.effects = kept
    if #kept == 0 then deleted[name] = true end
  end
end

-- Re-link prerequisites through deleted techs, then delete them.
local function resolve(name, out, seen)
  if seen[name] then return end
  seen[name] = true
  if not deleted[name] then out[#out + 1] = name; return end
  local t = data.raw.technology[name]
  for _, p in pairs(t and t.prerequisites or {}) do resolve(p, out, seen) end
end
for name, tech in pairs(data.raw.technology) do
  if not deleted[name] and tech.prerequisites then
    local out, seen = {}, { [name] = true }
    for _, p in pairs(tech.prerequisites) do resolve(p, out, seen) end
    tech.prerequisites = out
  end
end
for name in pairs(deleted) do data.raw.technology[name] = nil end

-- Remove references to deleted techs elsewhere (tips, shortcuts, achievements).
local function refs_deleted(t, seen)
  if type(t) ~= "table" then return false end
  seen = seen or {}
  if seen[t] then return false end
  seen[t] = true
  if type(t.technology) == "string" and deleted[t.technology] then return true end
  for _, v in pairs(t) do if refs_deleted(v, seen) then return true end end
  return false
end
for _, tip in pairs(data.raw["tips-and-tricks-item"] or {}) do
  if refs_deleted(tip.trigger) then tip.trigger = nil end
  if refs_deleted(tip.skip_trigger) then tip.skip_trigger = nil end
end
for _, sc in pairs(data.raw.shortcut or {}) do
  if sc.technology_to_unlock and deleted[sc.technology_to_unlock] then sc.technology_to_unlock = nil end
end
for name, a in pairs(data.raw["research-achievement"] or {}) do
  if a.technology and deleted[a.technology] then data.raw["research-achievement"][name] = nil end
end

---------------------------------------------------------------------------
-- No living enemies (plan 2.2). Asteroids are untouched.
-- control.lua also clears any enemy that still spawns, as a backstop.
---------------------------------------------------------------------------
local ENEMY_TYPES = { "unit-spawner", "unit", "segmented-unit", "spider-unit" }
local is_enemy = {}
for _, t in pairs(ENEMY_TYPES) do
  for n, p in pairs(data.raw[t] or {}) do is_enemy[n] = true; p.autoplace = nil end
end
for n, p in pairs(data.raw.turret or {}) do   -- worms are turrets with autoplace
  if p.autoplace then is_enemy[n] = true; p.autoplace = nil end
end
for _, planet in pairs(data.raw.planet or {}) do
  local mgs = planet.map_gen_settings
  if mgs then
    mgs.territory_settings = nil            -- demolisher territories on Vulcanus
    if mgs.autoplace_controls then
      for c in pairs(mgs.autoplace_controls) do
        if c:find("enemy") then mgs.autoplace_controls[c] = nil end
      end
    end
    local ent = mgs.autoplace_settings and mgs.autoplace_settings.entity
    if ent and ent.settings then
      for n in pairs(ent.settings) do if is_enemy[n] then ent.settings[n] = nil end end
    end
  end
end

---------------------------------------------------------------------------
-- Very rich ore patches (plan 3.2, Tom Q10): multiply richness on Nauvis ores
---------------------------------------------------------------------------
for _, r in ipairs(world) do
  if r.method == "ore" then
    local p = data.raw.resource[r.name]
    local ap = p and p.autoplace
    if ap and ap.richness_expression then
      ap.richness_expression = tostring(world.richness_multiplier) .. " * (" .. ap.richness_expression .. ")"
    elseif p then
      log("[factorio-irl] no richness_expression on " .. r.name)
    end
  end
end

---------------------------------------------------------------------------
-- Burners that start with free fuel (vanilla burner inserter starts with wood).
-- Nothing is free (pillar 1), and wood may no longer fit the burner's fuel
-- categories, so remove starting fuel everywhere.
---------------------------------------------------------------------------
local function strip_initial_fuel(t, seen)
  if type(t) ~= "table" or seen[t] then return end
  seen[t] = true
  if rawget(t, "type") == "burner" and rawget(t, "initial_fuel") then
    t.initial_fuel, t.initial_fuel_percent = nil, nil
  end
  for _, v in pairs(t) do strip_initial_fuel(v, seen) end
end
for _, list in pairs(data.raw) do
  for _, p in pairs(list) do strip_initial_fuel(p, {}) end
end
