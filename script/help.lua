-- Help system shell (plan section 4). Points the way, never gives anything.
-- Milestones come from the same master data as the recipes.

local mod_gui = require("mod-gui")
local milestones = require("data.master.milestones")

local H = {}
local by_id = {}
for _, m in pairs(milestones) do by_id[m.id] = m end

local BUTTON = "irl-help-button"
local FRAME = "irl-help-frame"
local SHOW = 5   -- how many next steps to list

local function state()
  storage.irl = storage.irl or {}
  local s = storage.irl
  s.done = s.done or {}     -- [force_index][id] = true
  s.built = s.built or {}   -- [force_index][entity name] = count
  return s
end

local function force_done(force)
  local s = state()
  s.done[force.index] = s.done[force.index] or {}
  return s.done[force.index]
end

local function available(m, done)
  if done[m.id] then return false end
  for _, r in pairs(m.requires) do if not done[r] then return false end end
  return true
end

-- Production statistics are per surface in 2.x; sum every surface.
local function produced(force, name)
  local total = 0
  local is_fluid = prototypes.fluid[name] ~= nil
  for _, surface in pairs(game.surfaces) do
    local stats = is_fluid and force.get_fluid_production_statistics(surface)
                          or force.get_item_production_statistics(surface)
    total = total + stats.get_input_count(name)
  end
  return total
end

local function is_done(force, m)
  local kind, name, count = m.done[1], m.done[2], m.done[3]
  if kind == "item-produced" then
    return produced(force, name) >= count
  elseif kind == "entity-built" then
    local b = state().built[force.index]
    return (b and b[name] or 0) >= count
  end
  return false
end

---------------------------------------------------------------- GUI
local function refresh(player)
  local flow = mod_gui.get_frame_flow(player)
  local frame = flow[FRAME]
  if not (frame and frame.valid) then return end
  frame.clear()
  local done = force_done(player.force)
  local n_done = 0
  for _ in pairs(done) do n_done = n_done + 1 end
  frame.add({ type = "label", caption = { "", "Milestones reached: ", n_done, " / ", #milestones } })
  local shown = 0
  for _, m in ipairs(milestones) do
    if shown < SHOW and available(m, done) then
      shown = shown + 1
      local title = frame.add({ type = "label", caption = m.title })
      title.style.font = "default-bold"
      local hint = frame.add({ type = "label", caption = m.hint })
      hint.style.single_line = false
      hint.style.maximal_width = 360
    end
  end
  if shown == 0 then frame.add({ type = "label", caption = "Nothing left to aim for. Well done." }) end
end

function H.ensure_button(player)
  local bf = mod_gui.get_button_flow(player)
  if not bf[BUTTON] then
    bf.add({ type = "sprite-button", name = BUTTON, sprite = "item/workbench", tooltip = "Next steps" })
  end
end

function H.toggle(player)
  local flow = mod_gui.get_frame_flow(player)
  if flow[FRAME] then flow[FRAME].destroy(); return end
  flow.add({ type = "frame", name = FRAME, direction = "vertical", caption = "Next steps" })
  refresh(player)
end

function H.refresh_force(force)
  for _, p in pairs(force.players) do refresh(p) end
end

---------------------------------------------------------------- tracking
function H.check_force(force)
  local done = force_done(force)
  local changed = true
  local any = false
  while changed do              -- a completion can make the next one available
    changed = false
    for _, m in ipairs(milestones) do
      if available(m, done) and is_done(force, m) then
        done[m.id] = true
        changed, any = true, true
        force.print({ "", "[font=default-bold]Milestone:[/font] ", m.title })
      end
    end
  end
  if any then H.refresh_force(force) end
end

function H.check_all()
  for _, force in pairs(game.forces) do
    if #force.players > 0 then H.check_force(force) end
  end
end

local tracked = {}
for _, m in pairs(milestones) do
  if m.done[1] == "entity-built" then tracked[m.done[2]] = true end
end

function H.on_built(entity)
  if not (entity and entity.valid) or not tracked[entity.name] then return end
  local s = state()
  local f = entity.force.index
  s.built[f] = s.built[f] or {}
  s.built[f][entity.name] = (s.built[f][entity.name] or 0) + 1
  H.check_force(entity.force)
end

function H.init()
  state()
  for _, p in pairs(game.players) do H.ensure_button(p) end
end

H.BUTTON = BUTTON
return H
