-- Run all offline checks:  lua5.2 tools/check.lua <path to wube/factorio-data> <path to this mod>
local FD, MOD = arg[1], arg[2] or "."
local raw = assert(loadfile(MOD .. "/tools/data_harness.lua"))(FD, MOD)
local report = assert(loadfile(MOD .. "/tools/verify.lua"))(raw, MOD)
print(report)
if not report:find("ALL CHECKS PASSED") then os.exit(1) end
