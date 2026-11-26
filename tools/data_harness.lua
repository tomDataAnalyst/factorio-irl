-- Offline data-stage harness. Loads the real Factorio data (core, base,
-- elevated-rails, recycler, space-age) from a checkout of wube/factorio-data,
-- then this mod, through all three data stages, and returns data.raw.
-- No game needed. Graphics files are never opened, only referenced.
--
-- Usage (any Lua 5.2+):  lua tools/data_harness.lua <factorio-data dir> <this mod dir>
-- Then tools/verify.lua runs checks on the result.

local FD, MOD = ...
FD = FD or arg and arg[1]
MOD = MOD or arg and arg[2]

local mod_roots = {
  core = FD .. "/core", base = FD .. "/base", ["elevated-rails"] = FD .. "/elevated-rails",
  recycler = FD .. "/recycler", ["space-age"] = FD .. "/space-age", ["factorio-irl"] = MOD,
}
local load_order = { "core", "base", "elevated-rails", "recycler", "space-age", "factorio-irl" }

mods = { base = "2.1.25", ["elevated-rails"] = "2.1.25", recycler = "2.1.25", ["space-age"] = "2.1.25", ["factorio-irl"] = "0.6.0" }
feature_flags = { quality = false, rail_bridges = true, space_travel = true, spoiling = true, freezing = true,
                  segmented_units = true, expansion_shaders = true, expansion = true }
settings = { startup = {} }
local function deep_defines() return setmetatable({}, { __index = function(t, k) local v = deep_defines(); rawset(t, k, v); return v end,
  __call = function() return 0 end }) end
defines = setmetatable({ direction = { north = 0, northnortheast = 1, northeast = 2, eastnortheast = 3, east = 4, eastsoutheast = 5,
  southeast = 6, southsoutheast = 7, south = 8, southsouthwest = 9, southwest = 10, westsouthwest = 11, west = 12,
  westnorthwest = 13, northwest = 14, northnorthwest = 15 } }, { __index = function(t, k) local v = deep_defines(); rawset(t, k, v); return v end })
LOGS = {}
function log(s) LOGS[#LOGS + 1] = tostring(s) end
function localised_print() end
serpent = { block = function(t) return tostring(t) end, line = function(t) return tostring(t) end, dump = function(t) return tostring(t) end }
table_size = function(t) local n = 0 for _ in pairs(t) do n = n + 1 end return n end
helpers = { compare_versions = function() return 0 end }

-- Factorio-style require: "__mod__/path", relative to current file, mod root, then core/lualib.
local current = {}  -- stack of { mod = name, dir = dir }
local loaded = {}
local function file_exists(p) local f = io.open(p, "r"); if f then f:close(); return true end end
local function resolve(name)
  name = name:gsub("%.lua$", "")
  local m, rest = name:match("^__([%w%-_]+)__[/.](.+)$")
  if m then
    local p = mod_roots[m] .. "/" .. rest .. ".lua"
    if not file_exists(p) then p = mod_roots[m] .. "/" .. rest:gsub("%.", "/") .. ".lua" end
    return m, p
  end
  local top = current[#current]
  local rel = name:gsub("%.", "/")
  local candidates = {}
  if top then
    candidates[#candidates + 1] = { top.mod, top.dir .. "/" .. rel .. ".lua" }
    candidates[#candidates + 1] = { top.mod, mod_roots[top.mod] .. "/" .. rel .. ".lua" }
  end
  candidates[#candidates + 1] = { "core", FD .. "/core/lualib/" .. rel .. ".lua" }
  for _, c in ipairs(candidates) do if file_exists(c[2]) then return c[1], c[2] end end
  if top then return top.mod, mod_roots[top.mod] .. "/" .. rel .. ".lua" end
  if rel:find("graphics/") then return top and top.mod or "core", mod_roots[top and top.mod or "core"] .. "/" .. rel .. ".lua" end
  error("harness: cannot resolve require '" .. name .. "' from " .. (top and top.dir or "?"))
end
-- Lua files shipped next to graphics are not in factorio-data; stand in a permissive stub.
local stub_mt = {}
stub_mt.__index = function(t, k) return setmetatable({}, stub_mt) end
stub_mt.__call = function() return setmetatable({}, stub_mt) end
function require(name)
  local mod, path = resolve(name)
  if loaded[path] ~= nil then return loaded[path] end
  if not file_exists(path) and path:find("/graphics/") then
    -- sprite metadata files: sizes and frame counts
    loaded[path] = setmetatable({ width = 64, height = 64, shift = { 0, 0 }, line_length = 1, frames = 1,
      scale = 0.5, animation_speed = 1 }, { __index = function(_, k) if k == "filenames" then return nil end return 1 end })
    return loaded[path]
  end
  if not file_exists(path) then   -- e.g. menu simulations: not shipped in factorio-data
    if path:find("/sound/") then
      loaded[path] = { type = "ambient-sound", name = path, track_type = "main-track" }
      return loaded[path]
    end
    loaded[path] = setmetatable({}, stub_mt)
    return loaded[path]
  end
  current[#current + 1] = { mod = mod, dir = path:match("^(.*)/[^/]*$") }
  local chunk = assert(loadfile(path))
  local ok, res = pcall(chunk)
  current[#current] = nil
  if not ok then error(res, 0) end
  if res == nil then res = true end
  loaded[path] = res
  return res
end

-- the official data loader defines `data` and data:extend
require("__core__/lualib/dataloader")
data.raw = data.raw or {}

for _, stage in ipairs({ "data", "data-updates", "data-final-fixes" }) do
  for _, mod in ipairs(load_order) do
    local path = mod_roots[mod] .. "/" .. stage .. ".lua"
    if file_exists(path) then
      current[#current + 1] = { mod = mod, dir = mod_roots[mod] }
      local chunk = assert(loadfile(path))
      local ok, err = pcall(chunk)
      current[#current] = nil
      if not ok then error("[" .. mod .. "/" .. stage .. "] " .. tostring(err), 0) end
    end
  end
end

return data.raw
