-- Game start rules: empty start (plan 2.1), no enemies (2.2), non-recipe
-- unlocks such as planets granted at start (Tom, Q4).

local S = {}

-- Freeplay gives starting items, a crash site and an intro. Turn all of it off.
function S.empty_start()
  local fp = remote.interfaces["freeplay"]
  if not fp then return end
  local function call(fn, ...) if fp[fn] then remote.call("freeplay", fn, ...) end end
  call("set_created_items", {})
  call("set_respawn_items", {})
  call("set_ship_items", {})
  call("set_debris_items", {})
  call("set_disable_crashsite", true)
  call("set_skip_intro", true)
end

function S.grant_foundations(force)
  local t = force.technologies["irl-foundations"]
  if t and not t.researched then t.researched = true end
end

function S.grant_all_forces()
  for _, force in pairs(game.forces) do S.grant_foundations(force) end
end

local function is_planet_surface(surface)
  return surface.platform == nil
end

-- Backstop for anything enemy that still spawns on a planet. Asteroids live on
-- platform surfaces and are left alone.
function S.clear_enemies(surface, area)
  if not is_planet_surface(surface) then return end
  local found = surface.find_entities_filtered({ area = area, force = "enemy" })
  for _, e in pairs(found) do
    if e.valid and e.type ~= "asteroid" then e.destroy() end
  end
end

function S.no_enemies_everywhere()
  game.map_settings.enemy_expansion.enabled = false
  for _, surface in pairs(game.surfaces) do S.clear_enemies(surface, nil) end
end

return S
