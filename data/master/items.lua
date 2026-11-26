-- Items (plan section 6).
--
-- name       internal name. Vanilla names are kept where the item already exists (plan 2.5).
-- vanilla    true = the item already exists; the generator only moves it to its era
--            subgroup (and its recipe may be reworked in recipes.lua).
-- era/group  menu placement: subgroup "<era>-<group>" (see eras.lua).
-- stack      stack size (new items only).
-- icon_from  vanilla/Space Age prototype whose icon is reused; tint = {r,g,b} over it.
-- fuel       { MJ, category }. Fuel categories:
--              "biomass"  : wood, sticks. Low heat. Burns in fire pits, kilns, charcoal pits, boilers.
--              "chemical" : vanilla category. Charcoal, coal, coke and up. High heat.
--            Bellows furnaces, bloomeries and blast furnaces accept "chemical" only, which is
--            how "you need charcoal plus bellows to smelt copper" is enforced (open question 4).

local function I(t) return t end

return {
  ---------------------------------------------------------------- 1. Stone Age
  I{ name = "wood",              vanilla = true, era = "stone", group = "raw", fuel = { 2, "biomass" } },
  I{ name = "stone",             vanilla = true, era = "stone", group = "raw" },
  I{ name = "stick",             era = "stone", group = "raw",       stack = 100, icon_from = "wood",        tint = { 0.8, 0.65, 0.45 }, fuel = { 0.5, "biomass" } },
  I{ name = "flint",             era = "stone", group = "raw",       stack = 50,  icon_from = "stone",       tint = { 0.35, 0.35, 0.4 } },
  I{ name = "plant-fiber",       era = "stone", group = "raw",       stack = 100, icon_from = "wood",        tint = { 0.55, 0.8, 0.3 } },
  I{ name = "clay",              era = "stone", group = "raw",       stack = 50,  icon_from = "stone",       tint = { 0.75, 0.5, 0.35 } },
  I{ name = "sand",              era = "stone", group = "raw",       stack = 100, icon_from = "stone",       tint = { 0.95, 0.85, 0.6 } },
  I{ name = "flint-flake",       era = "stone", group = "materials", stack = 100, icon_from = "stone",       tint = { 0.3, 0.3, 0.35 } },
  I{ name = "cordage",           era = "stone", group = "materials", stack = 100, icon_from = "copper-cable", tint = { 0.7, 0.6, 0.35 } },
  I{ name = "wooden-plank",      era = "stone", group = "materials", stack = 100, icon_from = "wood",        tint = { 0.9, 0.75, 0.5 }, fuel = { 1, "biomass" } },
  I{ name = "stone-hammer",      era = "stone", group = "tools",     stack = 20,  icon_from = "stone",       tint = { 0.6, 0.6, 0.6 } },
  I{ name = "flint-knife",       era = "stone", group = "tools",     stack = 20,  icon_from = "stone",       tint = { 0.3, 0.3, 0.35 } },
  I{ name = "flint-axe",         era = "stone", group = "tools",     stack = 20,  icon_from = "stone",       tint = { 0.4, 0.35, 0.3 } },
  I{ name = "pit-fire",          era = "stone", group = "stations",  stack = 10,  icon_from = "stone-furnace", tint = { 0.6, 0.5, 0.45 } },
  I{ name = "workbench",         era = "stone", group = "stations",  stack = 10,  icon_from = "assembling-machine-1", tint = { 0.8, 0.6, 0.4 } },
  I{ name = "wooden-chest",      vanilla = true, era = "stone", group = "logistics" },

  ---------------------------------------------------------------- 2. Clay and Fire
  I{ name = "stone-brick",       vanilla = true, era = "clay", group = "materials" },  -- now a fired clay brick
  I{ name = "limestone",         era = "clay", group = "raw",       stack = 50,  icon_from = "stone",       tint = { 0.95, 0.93, 0.8 } },
  I{ name = "charcoal",          era = "clay", group = "materials", stack = 50,  icon_from = "coal",        tint = { 0.5, 0.45, 0.45 }, fuel = { 4, "chemical" } },
  I{ name = "quicklime",         era = "clay", group = "materials", stack = 50,  icon_from = "stone",       tint = { 1, 1, 0.95 } },
  I{ name = "mortar",            era = "clay", group = "materials", stack = 100, icon_from = "stone",       tint = { 0.85, 0.85, 0.8 } },
  I{ name = "cloth",             era = "clay", group = "materials", stack = 100, icon_from = "copper-cable", tint = { 0.9, 0.85, 0.7 } },
  I{ name = "crucible",          era = "clay", group = "parts",     stack = 20,  icon_from = "stone-brick", tint = { 0.7, 0.45, 0.35 } },
  I{ name = "pottery-kiln",      era = "clay", group = "stations",  stack = 10,  icon_from = "stone-furnace", tint = { 0.85, 0.55, 0.4 } },
  I{ name = "charcoal-pit",      era = "clay", group = "stations",  stack = 10,  icon_from = "stone-furnace", tint = { 0.4, 0.35, 0.3 } },

  ---------------------------------------------------------------- 3. Copper and Bronze
  I{ name = "copper-ore",        vanilla = true, era = "bronze", group = "raw" },
  I{ name = "tin-ore",           era = "bronze", group = "raw",       stack = 50,  icon_from = "iron-ore",    tint = { 0.8, 0.8, 0.85 } },
  I{ name = "quartz",            era = "bronze", group = "raw",       stack = 50,  icon_from = "stone",       tint = { 0.95, 0.95, 1 } },
  I{ name = "lead-ore",          era = "bronze", group = "raw",       stack = 50,  icon_from = "iron-ore",    tint = { 0.5, 0.5, 0.6 } },
  I{ name = "zinc-ore",          era = "bronze", group = "raw",       stack = 50,  icon_from = "iron-ore",    tint = { 0.7, 0.75, 0.7 } },
  I{ name = "copper-plate",      vanilla = true, era = "bronze", group = "materials" },
  I{ name = "tin-plate",         era = "bronze", group = "materials", stack = 100, icon_from = "iron-plate",  tint = { 0.85, 0.85, 0.9 } },
  I{ name = "lead-plate",        era = "bronze", group = "materials", stack = 100, icon_from = "iron-plate",  tint = { 0.45, 0.45, 0.55 } },
  I{ name = "bronze-plate",      era = "bronze", group = "materials", stack = 100, icon_from = "copper-plate", tint = { 0.8, 0.6, 0.3 } },
  I{ name = "glass",             era = "bronze", group = "materials", stack = 100, icon_from = "iron-plate",  tint = { 0.7, 0.9, 0.95 } },
  I{ name = "bellows",           era = "bronze", group = "parts",     stack = 20,  icon_from = "wooden-chest", tint = { 0.7, 0.55, 0.4 } },
  I{ name = "anvil",             era = "bronze", group = "parts",     stack = 10,  icon_from = "iron-chest",  tint = { 0.8, 0.6, 0.3 } },
  I{ name = "bronze-tool-set",   era = "bronze", group = "tools",     stack = 20,  icon_from = "repair-pack", tint = { 0.8, 0.6, 0.3 } },
  I{ name = "bellows-furnace",   era = "bronze", group = "stations",  stack = 10,  icon_from = "stone-furnace", tint = { 0.8, 0.6, 0.45 } },

  ---------------------------------------------------------------- 4. Iron Age
  I{ name = "iron-ore",          vanilla = true, era = "iron", group = "raw" },
  I{ name = "iron-bloom",        era = "iron", group = "materials", stack = 50,  icon_from = "iron-ore",    tint = { 0.45, 0.4, 0.4 } },
  I{ name = "iron-plate",        vanilla = true, era = "iron", group = "materials" },   -- wrought iron
  I{ name = "brass-plate",       era = "iron", group = "materials", stack = 100, icon_from = "copper-plate", tint = { 0.95, 0.8, 0.35 } },
  I{ name = "iron-stick",        vanilla = true, era = "iron", group = "parts" },
  I{ name = "iron-tool-set",     era = "iron", group = "tools",     stack = 20,  icon_from = "repair-pack", tint = { 0.6, 0.6, 0.7 } },
  I{ name = "bloomery",          era = "iron", group = "stations",  stack = 10,  icon_from = "stone-furnace", tint = { 0.55, 0.45, 0.4 } },
  I{ name = "forge",             era = "iron", group = "stations",  stack = 10,  icon_from = "stone-furnace", tint = { 0.5, 0.4, 0.4 } },
  I{ name = "iron-chest",        vanilla = true, era = "iron", group = "logistics" },

  ---------------------------------------------------------------- 5. Mechanical Age
  I{ name = "iron-gear-wheel",   vanilla = true, era = "mechanical", group = "parts" },
  I{ name = "spring",            era = "mechanical", group = "parts",  stack = 100, icon_from = "iron-stick",  tint = { 0.7, 0.7, 0.8 } },
  I{ name = "screw",             era = "mechanical", group = "parts",  stack = 200, icon_from = "iron-stick",  tint = { 0.6, 0.6, 0.65 } },
  I{ name = "bronze-bushing",    era = "mechanical", group = "parts",  stack = 100, icon_from = "iron-gear-wheel", tint = { 0.8, 0.6, 0.3 } },
  I{ name = "lens",              era = "mechanical", group = "parts",  stack = 100, icon_from = "iron-plate",  tint = { 0.7, 0.9, 1 } },
  I{ name = "wooden-frame",      era = "mechanical", group = "parts",  stack = 50,  icon_from = "wooden-chest", tint = { 0.9, 0.75, 0.5 } },
  I{ name = "precision-instrument", era = "mechanical", group = "parts", stack = 50, icon_from = "iron-gear-wheel", tint = { 0.95, 0.8, 0.35 } },
  I{ name = "machinist-tool-set",  era = "mechanical", group = "tools", stack = 20,  icon_from = "repair-pack", tint = { 0.95, 0.8, 0.35 } },
  I{ name = "treadle-lathe",     era = "mechanical", group = "stations", stack = 10, icon_from = "assembling-machine-1", tint = { 0.85, 0.7, 0.5 } },
  I{ name = "machinist-bench",   era = "mechanical", group = "stations", stack = 10, icon_from = "assembling-machine-1", tint = { 0.7, 0.7, 0.75 } },

  ---------------------------------------------------------------- 6. Early Industrial
  I{ name = "coal",              vanilla = true, era = "early-industrial", group = "raw" },
  I{ name = "gravel",            era = "early-industrial", group = "raw",       stack = 100, icon_from = "stone",      tint = { 0.6, 0.55, 0.5 } },
  I{ name = "coke",              era = "early-industrial", group = "materials", stack = 50,  icon_from = "coal",       tint = { 0.6, 0.6, 0.65 }, fuel = { 6, "chemical" } },
  I{ name = "fire-brick",        era = "early-industrial", group = "materials", stack = 100, icon_from = "stone-brick", tint = { 0.95, 0.85, 0.65 } },
  I{ name = "pig-iron",          era = "early-industrial", group = "materials", stack = 100, icon_from = "iron-plate", tint = { 0.45, 0.45, 0.5 } },
  I{ name = "machine-frame",     era = "early-industrial", group = "parts",     stack = 50,  icon_from = "iron-chest", tint = { 0.35, 0.35, 0.4 } },
  I{ name = "cylinder-blank",    era = "early-industrial", group = "parts",     stack = 50,  icon_from = "pipe",       tint = { 0.4, 0.4, 0.45 } },
  I{ name = "steam-cylinder",    era = "early-industrial", group = "parts",     stack = 50,  icon_from = "pipe",       tint = { 0.7, 0.7, 0.75 } },
  I{ name = "precision-screw",   era = "early-industrial", group = "parts",     stack = 100, icon_from = "iron-stick", tint = { 0.85, 0.85, 0.9 } },
  I{ name = "pipe",              vanilla = true, era = "early-industrial", group = "logistics" },
  I{ name = "pipe-to-ground",    vanilla = true, era = "early-industrial", group = "logistics" },
  I{ name = "offshore-pump",     vanilla = true, era = "early-industrial", group = "logistics" },
  I{ name = "transport-belt",    vanilla = true, era = "early-industrial", group = "logistics" },
  I{ name = "burner-inserter",   vanilla = true, era = "early-industrial", group = "logistics" },
  I{ name = "burner-mining-drill", vanilla = true, era = "early-industrial", group = "stations" },
  I{ name = "stone-furnace",     vanilla = true, era = "early-industrial", group = "stations" }, -- role: puddling furnace
  I{ name = "coke-oven",         era = "early-industrial", group = "stations", stack = 10, icon_from = "stone-furnace", tint = { 0.45, 0.45, 0.5 } },
  I{ name = "blast-furnace",     era = "early-industrial", group = "stations", stack = 10, icon_from = "steel-furnace", tint = { 0.55, 0.45, 0.4 } },
  I{ name = "cupola-furnace",    era = "early-industrial", group = "stations", stack = 10, icon_from = "steel-furnace", tint = { 0.4, 0.4, 0.45 } },
  I{ name = "boring-mill",       era = "early-industrial", group = "stations", stack = 10, icon_from = "assembling-machine-1", tint = { 0.5, 0.5, 0.55 } },
  I{ name = "screw-cutting-lathe", era = "early-industrial", group = "stations", stack = 10, icon_from = "assembling-machine-1", tint = { 0.6, 0.6, 0.65 } },
  I{ name = "excavator",         era = "early-industrial", group = "stations", stack = 10, icon_from = "burner-mining-drill", tint = { 0.8, 0.7, 0.4 } },
  I{ name = "study",             era = "early-industrial", group = "science",  stack = 10, icon_from = "lab",            tint = { 0.8, 0.65, 0.45 } },
  I{ name = "automation-science-pack", vanilla = true, era = "early-industrial", group = "science" },

  ---------------------------------------------------------------- 7. Industrial
  I{ name = "steel-plate",       vanilla = true, era = "industrial", group = "materials" },
  I{ name = "copper-cable",      vanilla = true, era = "industrial", group = "materials" },
  I{ name = "solder",            era = "industrial", group = "materials", stack = 100, icon_from = "copper-cable", tint = { 0.75, 0.75, 0.8 } },
  I{ name = "cement",            era = "industrial", group = "materials", stack = 100, icon_from = "stone-brick",  tint = { 0.7, 0.7, 0.7 } },
  I{ name = "concrete",          vanilla = true, era = "industrial", group = "materials" },
  I{ name = "sulfur",            vanilla = true, era = "industrial", group = "materials" },
  I{ name = "engine-unit",       vanilla = true, era = "industrial", group = "parts" },
  I{ name = "relay",             era = "industrial", group = "parts",     stack = 100, icon_from = "electronic-circuit", tint = { 0.7, 0.55, 0.4 } },
  I{ name = "machine-tool-set",  era = "industrial", group = "tools",     stack = 20,  icon_from = "repair-pack",  tint = { 0.4, 0.5, 0.6 } },
  I{ name = "bessemer-converter",era = "industrial", group = "stations",  stack = 10,  icon_from = "steel-furnace", tint = { 0.7, 0.5, 0.35 } },
  I{ name = "steel-furnace",     vanilla = true, era = "industrial", group = "stations" },
  I{ name = "assembling-machine-1", vanilla = true, era = "industrial", group = "stations" },  -- "machine shop"
  I{ name = "boiler",            vanilla = true, era = "industrial", group = "stations" },
  I{ name = "steam-engine",      vanilla = true, era = "industrial", group = "stations" },
  I{ name = "electric-mining-drill", vanilla = true, era = "industrial", group = "stations" },
  I{ name = "chemical-plant",    vanilla = true, era = "industrial", group = "stations" },
  I{ name = "oil-refinery",      vanilla = true, era = "industrial", group = "stations" },
  I{ name = "pumpjack",          vanilla = true, era = "industrial", group = "stations" },
  I{ name = "small-electric-pole", vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "inserter",          vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "underground-belt",  vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "splitter",          vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "pump",              vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "storage-tank",      vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "rail",              vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "locomotive",        vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "cargo-wagon",       vanilla = true, era = "industrial", group = "logistics" },
  I{ name = "lab",               vanilla = true, era = "industrial", group = "science" },
  I{ name = "logistic-science-pack", vanilla = true, era = "industrial", group = "science" },

  ---------------------------------------------------------------- 8. Electronics
  I{ name = "plastic-bar",       vanilla = true, era = "electronics", group = "materials" },
  I{ name = "silicon",           era = "electronics", group = "materials", stack = 100, icon_from = "iron-plate", tint = { 0.4, 0.45, 0.55 } },
  I{ name = "silicon-wafer",     era = "electronics", group = "materials", stack = 100, icon_from = "iron-plate", tint = { 0.55, 0.6, 0.75 } },
  I{ name = "vacuum-tube",       era = "electronics", group = "parts",     stack = 100, icon_from = "electronic-circuit", tint = { 0.9, 0.7, 0.4 } },
  I{ name = "transistor",        era = "electronics", group = "parts",     stack = 200, icon_from = "electronic-circuit", tint = { 0.5, 0.5, 0.55 } },
  I{ name = "electronic-circuit",vanilla = true, era = "electronics", group = "parts" },
  I{ name = "advanced-circuit",  vanilla = true, era = "electronics", group = "parts" },
  I{ name = "processing-unit",   vanilla = true, era = "electronics", group = "parts" },
  I{ name = "battery",           vanilla = true, era = "electronics", group = "parts" },
  I{ name = "assembling-machine-2", vanilla = true, era = "electronics", group = "stations" },
  I{ name = "electric-furnace",  vanilla = true, era = "electronics", group = "stations" },
  I{ name = "fast-inserter",     vanilla = true, era = "electronics", group = "logistics" },
  I{ name = "medium-electric-pole", vanilla = true, era = "electronics", group = "logistics" },
  I{ name = "chemical-science-pack", vanilla = true, era = "electronics", group = "science" },

  ---------------------------------------------------------------- 9. Modern to Space Age
  I{ name = "bauxite",           era = "modern", group = "raw",       stack = 50,  icon_from = "copper-ore", tint = { 0.8, 0.45, 0.3 } },
  I{ name = "alumina",           era = "modern", group = "materials", stack = 100, icon_from = "stone",      tint = { 1, 1, 1 } },
  I{ name = "aluminium-plate",   era = "modern", group = "materials", stack = 100, icon_from = "iron-plate", tint = { 0.85, 0.88, 0.92 } },
  I{ name = "low-density-structure", vanilla = true, era = "modern", group = "parts" },
  I{ name = "firearm-magazine",  vanilla = true, era = "modern", group = "parts" },
  I{ name = "military-science-pack",   vanilla = true, era = "modern", group = "science" },
  I{ name = "production-science-pack", vanilla = true, era = "modern", group = "science" },
  I{ name = "utility-science-pack",    vanilla = true, era = "modern", group = "science" },
  I{ name = "space-science-pack",      vanilla = true, era = "modern", group = "science" },
  -- Every other vanilla and Space Age item not listed in this file is placed in
  -- the "modern" era by default and keeps its vanilla recipe until Phase 5.
}
