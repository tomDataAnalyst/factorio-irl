-- Shared helpers for the prototype generator (data stage only).

local U = {}

U.master = function(name) return require("__factorio-irl__.data.master." .. name) end

-- Every prototype type that behaves like an item (can be an ingredient or product).
U.item_types = {
  "item", "tool", "ammo", "capsule", "module", "gun", "armor", "repair-tool",
  "item-with-entity-data", "rail-planner", "space-platform-starter-pack",
  "item-with-inventory", "item-with-label", "item-with-tags", "selection-tool",
}

function U.find_item(name)
  for _, t in pairs(U.item_types) do
    local p = data.raw[t] and data.raw[t][name]
    if p then return p end
  end
end

U.entity_types = { "assembling-machine", "furnace", "lab", "mining-drill", "boiler", "generator" }

function U.find_entity(name)
  for _, t in pairs(U.entity_types) do
    local p = data.raw[t] and data.raw[t][name]
    if p then return p end
  end
end

-- "flint-flake" -> "Flint flake"
function U.title(name)
  local s = name:gsub("-", " ")
  return { "", (s:gsub("^%l", string.upper)) }
end

local function rgb(t) return { r = t[1], g = t[2], b = t[3], a = 1 } end

-- Icons of a prototype as an `icons` array, multiplied by tint.
function U.icons_from(src_name, tint)
  local src = U.find_item(src_name) or U.find_entity(src_name)
  assert(src, "icon_from: no prototype named " .. tostring(src_name))
  local icons = src.icons and table.deepcopy(src.icons)
    or { { icon = src.icon, icon_size = src.icon_size or 64 } }
  if tint then
    for _, layer in pairs(icons) do layer.tint = rgb(tint) end
  end
  return icons
end

-- Tint every sprite in an entity's graphics, except shadows and lights.
function U.tint_graphics(tbl, tint, seen)
  if type(tbl) ~= "table" then return end
  seen = seen or {}
  if seen[tbl] then return end
  seen[tbl] = true
  local raw = rawget
  if (raw(tbl, "filename") or raw(tbl, "filenames") or raw(tbl, "stripes"))
     and not (raw(tbl, "draw_as_shadow") or raw(tbl, "draw_as_light") or raw(tbl, "draw_as_glow")) then
    tbl.tint = rgb(tint)
  end
  for k, v in pairs(tbl) do
    if k ~= "icons" and k ~= "icon" then U.tint_graphics(v, tint, seen) end
  end
end

-- { "iron-plate", 2 } / { "water", 10, fluid = true, probability = 0.5 } -> product/ingredient prototype
function U.expand(list)
  local out = {}
  for _, e in pairs(list) do
    out[#out + 1] = {
      type = e.fluid and "fluid" or "item",
      name = e[1],
      amount = e[2],
      -- 2.1 renamed product `probability`; independent_probability is the per-product roll.
      independent_probability = e.probability,
    }
  end
  return out
end

function U.add_unique(list, value)
  for _, v in pairs(list) do if v == value then return end end
  list[#list + 1] = value
end

return U
