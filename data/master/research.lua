-- Upgrade research (plan 2.3). Research never unlocks recipes. All science
-- pack assignments below are a PROPOSAL pending Tom's answer (open question 1).
--
-- Tom's rule (Q8): no science packs exist in play until an improvement needs them.
-- Proposal: the first pack (red) appears in the Early Industrial era, with the
-- "study" as the first lab. Eras 1-5 have no research at all.
--
-- packs      { pack, count } per research unit
-- units      number of units
-- effects    { modifier type, value }  (TechnologyModifier types, to verify in Phase 2)
-- keep       true = keep the vanilla/Space Age technology as it is (it only has
--            modifier effects). Phase 2 strips recipe unlocks from every other tech.

local red    = { "automation-science-pack", 1 }
local green  = { "logistic-science-pack", 1 }
local blue   = { "chemical-science-pack", 1 }

local function T(t) return t end

return {
  science_packs = {
    { pack = "automation-science-pack", era = "early-industrial", lab = "study" },
    { pack = "logistic-science-pack",   era = "industrial",       lab = "lab" },
    { pack = "chemical-science-pack",   era = "electronics",      lab = "lab" },
    { pack = "military-science-pack",   era = "modern",           lab = "lab", note = "Needed for asteroid turret upgrades." },
    { pack = "production-science-pack", era = "modern",           lab = "lab" },
    { pack = "utility-science-pack",    era = "modern",           lab = "lab" },
    { pack = "space-science-pack",      era = "modern",           lab = "lab", note = "Space Age planetary packs unchanged." },
  },

  technologies = {
    ---------------------------------------------------------------- Early Industrial (red)
    T{ name = "nimble-hands-1",   era = "early-industrial", packs = { red }, units = 50,
       effects = { { "character-crafting-speed", 0.25 } } },
    T{ name = "sure-footing-1",   era = "early-industrial", packs = { red }, units = 50,
       effects = { { "character-running-speed", 0.15 } } },
    T{ name = "satchel",          era = "early-industrial", packs = { red }, units = 75,
       effects = { { "character-inventory-slots-bonus", 10 } } },
    T{ name = "long-reach-1",     era = "early-industrial", packs = { red }, units = 50,
       effects = { { "character-reach-distance", 2 }, { "character-build-distance", 2 }, { "character-resource-reach-distance", 1 } } },

    ---------------------------------------------------------------- Industrial (red + green)
    T{ name = "nimble-hands-2",   era = "industrial", packs = { red, green }, units = 100, requires = { "nimble-hands-1" },
       effects = { { "character-crafting-speed", 0.25 } } },
    T{ name = "sure-footing-2",   era = "industrial", packs = { red, green }, units = 100, requires = { "sure-footing-1" },
       effects = { { "character-running-speed", 0.15 } } },
    T{ name = "toolbelt",              keep = true, era = "industrial" },
    T{ name = "steel-axe",             keep = true, era = "industrial" },
    T{ name = "mining-productivity-1", keep = true, era = "industrial" },
    T{ name = "inserter-capacity-bonus-1", keep = true, era = "industrial" },
    T{ name = "inserter-capacity-bonus-2", keep = true, era = "industrial" },
    T{ name = "research-speed-1",      keep = true, era = "industrial" },
    T{ name = "research-speed-2",      keep = true, era = "industrial" },

    ---------------------------------------------------------------- Electronics (+ blue)
    T{ name = "nimble-hands-3",   era = "electronics", packs = { red, green, blue }, units = 200, requires = { "nimble-hands-2" },
       effects = { { "character-crafting-speed", 0.5 } } },
    T{ name = "long-reach-2",     era = "electronics", packs = { red, green, blue }, units = 150, requires = { "long-reach-1" },
       effects = { { "character-reach-distance", 4 }, { "character-build-distance", 4 } } },
    T{ name = "mining-productivity-2", keep = true, era = "electronics" },
    T{ name = "inserter-capacity-bonus-3", keep = true, era = "electronics" },

    ---------------------------------------------------------------- Modern / Space Age
    -- All remaining vanilla and Space Age technologies whose only effects are
    -- modifiers stay as they are: physical-projectile-damage-*, weapon-shooting-speed-*,
    -- laser and rocket damage (asteroid defence), worker robot speed/storage,
    -- inserter capacity, research speed, mining productivity, and the Space Age
    -- productivity researches (steel-plate, processing-unit, low-density-structure,
    -- plastic-bar, rocket-fuel, rocket-part, asteroid). Quality research is removed.
    T{ name = "vanilla-modifier-techs", keep = true, era = "modern", rule = "keep every technology whose effects are all modifiers" },
  },
}
