-- Crafting stations (plan sections 2.4 and 6).
--
-- categories   recipe categories this station crafts (RecipeCategory names).
-- type         prototype type to build: "assembling-machine" (player picks the recipe)
--              or "furnace" (recipe picked from input; every recipe in its categories
--              must have exactly one ingredient).
-- entity_from  vanilla entity whose graphics and size are reused, tinted with `tint`.
-- energy       "void"  = muscle power. Works with no fuel. Mechanical power (water,
--                        wind, animals) is on hold (Tom, Q7), so hand- and foot-powered
--                        machines are modelled this way.
--              "burner" with fuel_categories.
--              "electric".
-- speed        crafting_speed.
-- The recipe that builds each station lives in recipes.lua under the same name.
--
-- `vanilla_extend` rows add our categories to existing vanilla machines so that
-- later machines can automate earlier recipes (an assembler can do workbench work).

-- Character: only true hand work (plan 2.4). Replaces vanilla "crafting".
local character_categories = { "hand" }

local stations = {
  ---------------------------------------------------------------- Stone Age
  { name = "pit-fire",     era = "stone", type = "assembling-machine", entity_from = "stone-furnace", tint = { 0.6, 0.5, 0.45 },
    categories = { "fire" }, energy = { "burner", { "biomass", "chemical" } }, speed = 0.5,
    note = "Open pit firing: low temperature, slow, but enough for the first bricks." },
  { name = "workbench",    era = "stone", type = "assembling-machine", entity_from = "assembling-machine-1", tint = { 0.8, 0.6, 0.4 },
    categories = { "hand", "workbench" }, energy = { "void" }, speed = 0.5 },

  ---------------------------------------------------------------- Clay and Fire
  { name = "pottery-kiln", era = "clay", type = "assembling-machine", entity_from = "stone-furnace", tint = { 0.85, 0.55, 0.4 },
    categories = { "fire", "kiln" }, energy = { "burner", { "biomass", "chemical" } }, speed = 1 },
  { name = "charcoal-pit", era = "clay", type = "furnace", entity_from = "stone-furnace", tint = { 0.4, 0.35, 0.3 },
    categories = { "charring" }, energy = { "burner", { "biomass", "chemical" } }, speed = 1 },

  ---------------------------------------------------------------- Copper and Bronze
  { name = "bellows-furnace", era = "bronze", type = "assembling-machine", entity_from = "stone-furnace", tint = { 0.8, 0.6, 0.45 },
    categories = { "furnace-smelting", "alloying", "casting" }, energy = { "burner", { "chemical" } }, speed = 1,
    note = "Charcoal-only (no wood): copper melts at 1085 C, which needs charcoal and a forced draft." },

  ---------------------------------------------------------------- Iron Age
  { name = "bloomery",     era = "iron", type = "furnace", entity_from = "stone-furnace", tint = { 0.55, 0.45, 0.4 },
    categories = { "bloomery" }, energy = { "burner", { "chemical" } }, speed = 1 },
  { name = "forge",        era = "iron", type = "assembling-machine", entity_from = "stone-furnace", tint = { 0.5, 0.4, 0.4 },
    categories = { "forging" }, energy = { "burner", { "chemical" } }, speed = 1 },

  ---------------------------------------------------------------- Mechanical Age
  { name = "treadle-lathe",   era = "mechanical", type = "assembling-machine", entity_from = "assembling-machine-1", tint = { 0.85, 0.7, 0.5 },
    categories = { "turning" }, energy = { "void" }, speed = 0.5,
    note = "Foot-powered. Would be line-shaft powered if mechanical power is approved later." },
  { name = "machinist-bench", era = "mechanical", type = "assembling-machine", entity_from = "assembling-machine-1", tint = { 0.7, 0.7, 0.75 },
    categories = { "hand", "workbench", "fitting" }, energy = { "void" }, speed = 0.75 },

  ---------------------------------------------------------------- Early Industrial
  { name = "coke-oven",      era = "early-industrial", type = "furnace", entity_from = "stone-furnace", tint = { 0.45, 0.45, 0.5 },
    categories = { "coking" }, energy = { "burner", { "chemical" } }, speed = 1 },
  { name = "blast-furnace",  era = "early-industrial", type = "assembling-machine", entity_from = "steel-furnace", tint = { 0.55, 0.45, 0.4 },
    categories = { "blast-furnace" }, energy = { "burner", { "chemical" } }, speed = 2 },
  { name = "cupola-furnace", era = "early-industrial", type = "assembling-machine", entity_from = "steel-furnace", tint = { 0.4, 0.4, 0.45 },
    categories = { "iron-casting", "casting", "furnace-smelting", "alloying" }, energy = { "burner", { "chemical" } }, speed = 1 },
  { name = "boring-mill",    era = "early-industrial", type = "furnace", entity_from = "assembling-machine-1", tint = { 0.5, 0.5, 0.55 },
    categories = { "boring" }, energy = { "void" }, speed = 0.5,
    note = "Wilkinson's 1774 mill was water-powered. Void energy until mechanical power is decided (open question 3)." },
  { name = "screw-cutting-lathe", era = "early-industrial", type = "assembling-machine", entity_from = "assembling-machine-2", tint = { 0.6, 0.6, 0.65 },
    categories = { "turning", "fitting", "machining" }, energy = { "burner", { "chemical" } }, speed = 1,
    note = "Burner = a small steam engine driving the machine, abstracted (plan pillar 4)." },
  { name = "excavator",      era = "early-industrial", type = "assembling-machine", entity_from = "burner-mining-drill", tint = { 0.8, 0.7, 0.4 },
    categories = { "excavating" }, energy = { "burner", { "chemical" } }, speed = 1,
    note = "Recipe is set by script from the tile under it (resources.lua excavator rows). Steam shovel, 1839." },
  { name = "study",          era = "early-industrial", type = "lab", entity_from = "lab", tint = { 0.8, 0.65, 0.45 },
    inputs = { "automation-science-pack" }, energy = { "void" }, speed = 0.5,
    note = "A natural philosopher's study: the first lab. Pending Tom's answer on science (open question 1)." },

  ---------------------------------------------------------------- Industrial
  { name = "bessemer-converter", era = "industrial", type = "furnace", entity_from = "steel-furnace", tint = { 0.7, 0.5, 0.35 },
    categories = { "steelmaking" }, energy = { "electric" }, speed = 2,
    note = "Air blown through molten pig iron burns out carbon; no fuel needed. Electric stands in for the blowing engine." },
}

-- Categories added to vanilla machines.
local vanilla_extend = {
  ["stone-furnace"]        = { categories = { "smelting" }, energy = { "burner", { "chemical" } } }, -- role: puddling furnace
  ["steel-furnace"]        = { add = { "steelmaking" } },
  ["electric-furnace"]     = { add = { "steelmaking", "arc-smelting", "electrolysis" } },
  ["burner-mining-drill"]  = {},  -- first drill (steam drill, 1849); unchanged
  ["assembling-machine-1"] = { add = { "hand", "workbench", "fitting", "turning" } },
  ["assembling-machine-2"] = { add = { "hand", "workbench", "fitting", "turning", "machining", "forging" } },
  ["assembling-machine-3"] = { add = { "hand", "workbench", "fitting", "turning", "machining", "forging" } },
  ["lab"]                  = {},  -- inputs unchanged
}

return {
  character_categories = character_categories,
  stations = stations,
  vanilla_extend = vanilla_extend,
}
