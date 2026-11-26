-- Phase 3 (data stage): new ore patches, pickable entities, excavator.
-- Placement of pickables and regrowth are scripted (script/world.lua).

local U = require("prototypes.util")
local R = U.master("resources")
local st = U.master("stations")
local resource_autoplace = require("resource-autoplace")

local new = {}
local nauvis = data.raw.planet and data.raw.planet.nauvis
local mgs = nauvis and nauvis.map_gen_settings

local function scale_graphics(t, f, seen)
  if type(t) ~= "table" then return end
  seen = seen or {}
  if seen[t] then return end
  seen[t] = true
  if rawget(t, "filename") or rawget(t, "filenames") or rawget(t, "stripes") then
    t.scale = (t.scale or 1) * f
    if t.shift then t.shift = { (t.shift[1] or t.shift.x or 0) * f, (t.shift[2] or t.shift.y or 0) * f } end
  end
  for k, v in pairs(t) do
    if k ~= "icons" and k ~= "icon" then scale_graphics(v, f, seen) end
  end
end

local function find_world_entity(name)
  for _, t in pairs({ "simple-entity", "tree", "resource" }) do
    if data.raw[t] and data.raw[t][name] then return data.raw[t][name] end
  end
end

for i, r in ipairs(R) do
  -------------------------------------------------------------- new ore patches
  if r.method == "ore" and not r.vanilla then
    local base = data.raw.resource[r.entity_from]
    assert(base, "ore " .. r.name .. ": no resource " .. r.entity_from)
    local e = table.deepcopy(base)
    e.name = r.name
    e.localised_name = U.title(r.name)
    e.icons = U.icons_from(r.entity_from, r.tint)
    e.icon, e.icon_size = nil, nil
    e.map_color = { r = r.tint[1], g = r.tint[2], b = r.tint[3] }
    e.minable = table.deepcopy(base.minable)
    e.minable.result, e.minable.count = nil, nil
    e.minable.results = U.expand(r.results)
    e.minable.mining_particle = base.minable.mining_particle
    U.tint_graphics(e, r.tint)
    resource_autoplace.initialize_patch_set(r.name, r.starting_area)
    e.autoplace = resource_autoplace.resource_autoplace_settings({
      name = r.name,
      order = "c-irl-" .. i,
      base_density = r.base_density,
      has_starting_area_placement = r.starting_area,
      regular_rq_factor_multiplier = 1.0,
      starting_rq_factor_multiplier = 1.1,
    })
    new[#new + 1] = e
    new[#new + 1] = {
      type = "autoplace-control", name = r.name, localised_name = U.title(r.name),
      richness = true, order = "b-irl-" .. i, category = "resource",
    }
    if mgs then
      mgs.autoplace_controls = mgs.autoplace_controls or {}
      mgs.autoplace_controls[r.name] = {}
      mgs.autoplace_settings = mgs.autoplace_settings or {}
      mgs.autoplace_settings.entity = mgs.autoplace_settings.entity or { settings = {} }
      mgs.autoplace_settings.entity.settings[r.name] = {}
    end

  -------------------------------------------------------------- pickables
  elseif r.method == "pickable" then
    local base = find_world_entity(r.entity_from)
    assert(base, "pickable " .. r.name .. ": no entity " .. r.entity_from)
    local e = table.deepcopy(base)
    e.name = r.name
    e.localised_name = U.title(r.name)
    e.icons = U.icons_from(r.results[1][1], r.tint)
    e.icon, e.icon_size = nil, nil
    e.autoplace = nil
    e.minable = { mining_time = r.mining_time, results = U.expand(r.results) }
    e.collision_box = { { -0.3, -0.3 }, { 0.3, 0.3 } }
    e.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    e.loot = nil
    e.remains_when_mined = nil
    e.map_color = nil
    e.count_as_rock_for_filtered_deconstruction = nil
    scale_graphics(e, 0.45)
    U.tint_graphics(e, r.tint)
    new[#new + 1] = e

  -------------------------------------------------------------- excavator recipes
  elseif r.method == "excavator" then
    new[#new + 1] = {
      type = "recipe", name = r.name, localised_name = U.title(r.name),
      categories = { "excavating" }, energy_required = 2,
      ingredients = {}, results = U.expand(r.results),
      enabled = true, subgroup = "irl-early-industrial-raw", order = "z" .. i,
    }
  end
end

---------------------------------------------------------------------- excavator entity
for _, s in pairs(st.stations) do
  if s.name == "excavator" then
    local base = data.raw["mining-drill"][s.entity_from]
    local e = table.deepcopy(base)
    e.type = "assembling-machine"
    e.name = "excavator"
    e.localised_name = U.title("excavator")
    e.icons = U.icons_from("burner-mining-drill", { 0.8, 0.7, 0.4 })
    e.icon, e.icon_size = nil, nil
    e.minable = { mining_time = 0.3, result = "excavator" }
    e.crafting_categories = { "excavating" }
    e.crafting_speed = s.speed
    e.energy_usage = base.energy_usage or "150kW"
    e.next_upgrade, e.fast_replaceable_group = nil, nil
    -- mining-drill only fields
    e.mining_speed, e.resource_categories, e.resource_searching_radius = nil, nil, nil
    e.vector_to_place_result, e.output_fluid_box, e.input_fluid_box = nil, nil, nil
    e.monitor_visualization_tint, e.radius_visualisation_picture = nil, nil
    if e.energy_source and e.energy_source.type == "burner" then
      e.energy_source.fuel_categories = table.deepcopy(s.energy[2])
    end
    U.tint_graphics(e, s.tint)
    new[#new + 1] = e
    data.raw.item["excavator"].place_result = "excavator"
  end
end

data:extend(new)
