-- Data stage: builds every NEW prototype from the master data (plan section 6).
-- Changes to existing vanilla/Space Age prototypes happen in rules.lua
-- (data-final-fixes), so they apply after Space Age's own data-updates.

local U = require("prototypes.util")
local eras      = U.master("eras")
local items     = U.master("items")
local recipes   = U.master("recipes")
local st        = U.master("stations")
local research  = U.master("research")

local era_order = {}
for _, e in pairs(eras) do era_order[e.name] = e.order end

local function subgroup_name(era, group) return "irl-" .. era .. "-" .. group end
local function order_for(era, i) return era_order[era] .. string.format("%04d", i) end

---------------------------------------------------------------------------
-- Item groups and subgroups, one group per era (plan 2.6)
---------------------------------------------------------------------------
local new = {}
for _, era in pairs(eras) do
  if not era.placeholder then
    new[#new + 1] = {
      type = "item-group", name = "irl-" .. era.name, order = "0-" .. era.order,
      localised_name = U.title(era.name),
      icons = U.icons_from(era.icon_from),
    }
    for i, g in pairs(era.subgroups) do
      new[#new + 1] = { type = "item-subgroup", name = subgroup_name(era.name, g),
                        group = "irl-" .. era.name, order = string.format("%02d", i) }
    end
  end
end

---------------------------------------------------------------------------
-- Recipe categories and the biomass fuel category
---------------------------------------------------------------------------
local categories = {}
local function want_category(c) categories[c] = true end
for _, r in pairs(recipes) do for _, c in pairs(r.stations) do want_category(c) end end
for _, s in pairs(st.stations) do for _, c in pairs(s.categories or {}) do want_category(c) end end
for _, c in pairs(st.character_categories) do want_category(c) end
for _, ext in pairs(st.vanilla_extend) do
  for _, c in pairs(ext.add or {}) do want_category(c) end
  for _, c in pairs(ext.categories or {}) do want_category(c) end
end
for c in pairs(categories) do
  if not data.raw["recipe-category"][c] then
    new[#new + 1] = { type = "recipe-category", name = c }
  end
end
if not data.raw["fuel-category"]["biomass"] then
  new[#new + 1] = { type = "fuel-category", name = "biomass" }
end

---------------------------------------------------------------------------
-- New items
---------------------------------------------------------------------------
local station_by_name = {}
for _, s in pairs(st.stations) do station_by_name[s.name] = s end
local item_row = {}
for _, it in pairs(items) do item_row[it.name] = it end

for i, it in ipairs(items) do
  if not it.vanilla then
    local s = station_by_name[it.name]
    local p = {
      type = "item",
      name = it.name,
      localised_name = U.title(it.name),
      icons = U.icons_from(it.icon_from, it.tint),
      subgroup = subgroup_name(it.era, it.group),
      order = order_for(it.era, i),
      stack_size = it.stack,
    }
    if it.fuel then
      p.fuel_value = it.fuel[1] .. "MJ"
      p.fuel_categories = { it.fuel[2] }
    end
    if s and s.phase ~= 3 then p.place_result = s.name end
    new[#new + 1] = p
  end
end

---------------------------------------------------------------------------
-- Stations (entities)
---------------------------------------------------------------------------
local function energy_source(spec, base)
  local kind = spec[1]
  if kind == "void" then return { type = "void" } end
  if kind == "electric" then
    return { type = "electric", usage_priority = "secondary-input", emissions_per_minute = { pollution = 4 } }
  end
  -- burner: keep the base entity's smoke and light if it already burned fuel
  local es = (base.energy_source and base.energy_source.type == "burner")
    and table.deepcopy(base.energy_source)
    or { type = "burner", effectivity = 1, emissions_per_minute = { pollution = 2 } }
  es.fuel_categories = table.deepcopy(spec[2])
  es.fuel_category = nil
  es.fuel_inventory_size = es.fuel_inventory_size or 1
  return es
end

for _, s in pairs(st.stations) do
  if s.phase ~= 3 then
    local base = U.find_entity(s.entity_from)
    assert(base, "station " .. s.name .. ": no entity " .. s.entity_from)
    local e = table.deepcopy(base)
    e.type = s.type
    e.name = s.name
    e.localised_name = U.title(s.name)
    e.localised_description = nil
    local row = item_row[s.name]
    e.icons = U.icons_from(row.icon_from, row.tint)
    e.icon, e.icon_size = nil, nil
    e.minable = { mining_time = 0.2, result = s.name }
    e.placeable_by = nil
    e.next_upgrade = nil
    e.fast_replaceable_group = nil
    e.fixed_recipe = nil
    e.energy_source = energy_source(s.energy, base)
    if s.type == "lab" then
      e.inputs = table.deepcopy(s.inputs)
      e.researching_speed = s.speed
    else
      e.crafting_categories = table.deepcopy(s.categories)
      e.crafting_speed = s.speed
      if s.type == "furnace" then
        e.source_inventory_size = 1
        e.result_inventory_size = 1
      else
        e.source_inventory_size, e.result_inventory_size = nil, nil
      end
    end
    U.tint_graphics(e, s.tint)
    new[#new + 1] = e
  end
end

---------------------------------------------------------------------------
-- New recipes (vanilla = true rows are applied in rules.lua)
---------------------------------------------------------------------------
for i, r in ipairs(recipes) do
  if not r.vanilla then
    new[#new + 1] = {
      type = "recipe",
      name = r.name,
      -- recipes named after their item take the item's name automatically
      localised_name = (item_row[r.name] or U.find_item(r.name)) and nil or U.title(r.name),
      categories = table.deepcopy(r.stations),
      energy_required = r.time,
      ingredients = U.expand(r.ingredients),
      results = U.expand(r.results or { { r.name, 1 } }),
      enabled = true,
      order = order_for(r.era, i),
    }
  end
end

---------------------------------------------------------------------------
-- New upgrade research (keep = true rows are vanilla techs, handled in rules.lua)
---------------------------------------------------------------------------
for _, t in pairs(research.technologies) do
  if not t.keep then
    local effects = {}
    for _, e in pairs(t.effects) do effects[#effects + 1] = { type = e[1], modifier = e[2] } end
    local ingredients = {}
    for _, p in pairs(t.packs) do ingredients[#ingredients + 1] = { p[1], p[2] } end
    new[#new + 1] = {
      type = "technology",
      name = t.name,
      localised_name = U.title(t.name),
      icons = table.deepcopy(data.raw.technology["toolbelt"].icons)
        or { { icon = data.raw.technology["toolbelt"].icon, icon_size = data.raw.technology["toolbelt"].icon_size or 256 } },
      effects = effects,
      prerequisites = t.requires and table.deepcopy(t.requires) or nil,
      unit = { count = t.units, ingredients = ingredients, time = 30 },
    }
  end
end

-- Hidden technology that carries every non-recipe unlock (planets, platforms,
-- mining with fluid...). rules.lua fills its effects; control.lua researches it
-- at game start, so these are available from the beginning (Tom, Q4).
new[#new + 1] = {
  type = "technology",
  name = "irl-foundations",
  localised_name = { "", "Foundations" },
  icons = table.deepcopy(data.raw.technology["toolbelt"].icons)
    or { { icon = data.raw.technology["toolbelt"].icon, icon_size = data.raw.technology["toolbelt"].icon_size or 256 } },
  hidden = true,
  effects = {},
  unit = { count = 1, ingredients = { { "automation-science-pack", 1 } }, time = 1 },
}

data:extend(new)
