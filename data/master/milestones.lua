-- Help-system milestones (plan section 4). They point the way and never give
-- anything. Completion is detected from production statistics (item-produced)
-- or build events (entity-built), tracked per force in `storage`.
--
-- id        unique id
-- era       era it belongs to
-- title     short panel title
-- hint      what to aim for and roughly why
-- done      { "item-produced", item, count } or { "entity-built", entity, count }
-- requires  ids of milestones that must be complete before this one shows

local function M(t) return t end

return {
  ------------------------------------------------------------------ 1. Stone Age
  M{ id = "first-flakes", era = "stone", title = "Sharp edges",
     hint = "Pick flint off the ground and knap it into flakes. Every early tool starts here.",
     done = { "item-produced", "flint-flake", 1 }, requires = {} },
  M{ id = "first-cordage", era = "stone", title = "String",
     hint = "Gather plant fibre from grass and twist it into cordage to lash tools together.",
     done = { "item-produced", "cordage", 1 }, requires = {} },
  M{ id = "first-tools", era = "stone", title = "A toolkit",
     hint = "Make a flint axe, a flint knife and a stone hammer.",
     done = { "item-produced", "flint-axe", 1 }, requires = { "first-flakes", "first-cordage" } },
  M{ id = "first-workbench", era = "stone", title = "A place to work",
     hint = "Your tools and some wood make a workbench. Most crafting needs a station from now on.",
     done = { "entity-built", "workbench", 1 }, requires = { "first-tools" } },
  M{ id = "first-pit-fire", era = "stone", title = "Fire",
     hint = "Ring stones around sticks to make a pit fire. It can fire clay from riverbanks into bricks.",
     done = { "entity-built", "pit-fire", 1 }, requires = {} },
  M{ id = "first-bricks", era = "stone", title = "Fired clay",
     hint = "Fire clay in the pit fire. It is slow, but you need 20 bricks for a proper kiln.",
     done = { "item-produced", "stone-brick", 20 }, requires = { "first-pit-fire" } },

  ------------------------------------------------------------------ 2. Clay and Fire
  M{ id = "first-kiln", era = "clay", title = "The first kiln",
     hint = "Bricks, clay and stone make a pottery kiln: hotter, faster, and the end of the Stone Age.",
     done = { "entity-built", "pottery-kiln", 1 }, requires = { "first-bricks", "first-workbench" } },
  M{ id = "first-charcoal", era = "clay", title = "Charcoal",
     hint = "Build a charcoal pit and char wood. Charcoal burns hot enough to melt metal.",
     done = { "item-produced", "charcoal", 1 }, requires = { "first-workbench" } },
  M{ id = "first-lime", era = "clay", title = "Lime",
     hint = "Burn limestone in the kiln for quicklime, then mix it with sand for mortar.",
     done = { "item-produced", "mortar", 1 }, requires = { "first-kiln" } },
  M{ id = "first-crucible", era = "clay", title = "A pot for metal",
     hint = "Fire a sand-tempered clay crucible. Molten copper needs one.",
     done = { "item-produced", "crucible", 1 }, requires = { "first-kiln" } },

  ------------------------------------------------------------------ 3. Copper and Bronze
  M{ id = "first-bellows", era = "bronze", title = "Forced air",
     hint = "Weave cloth and build bellows. Air driven into charcoal makes it far hotter.",
     done = { "item-produced", "bellows", 1 }, requires = { "first-workbench" } },
  M{ id = "first-copper", era = "bronze", title = "Copper",
     hint = "A bellows furnace fuelled with charcoal smelts copper ore. Wood is not hot enough.",
     done = { "item-produced", "copper-plate", 1 }, requires = { "first-bellows", "first-charcoal", "first-crucible", "first-lime" } },
  M{ id = "first-bronze", era = "bronze", title = "Bronze",
     hint = "Tin comes from quartz veins. Alloy three copper to one tin.",
     done = { "item-produced", "bronze-plate", 1 }, requires = { "first-copper" } },
  M{ id = "first-anvil", era = "bronze", title = "An anvil",
     hint = "Cast a bronze anvil. You will need it to work iron.",
     done = { "item-produced", "anvil", 1 }, requires = { "first-bronze" } },
  M{ id = "first-glass", era = "bronze", title = "Glass",
     hint = "Melt sand with quicklime in the bellows furnace.",
     done = { "item-produced", "glass", 1 }, requires = { "first-copper" } },

  ------------------------------------------------------------------ 4. Iron Age
  M{ id = "first-bloom", era = "iron", title = "Iron bloom",
     hint = "Build a bloomery. Iron never melts in it; it becomes a spongy bloom full of slag.",
     done = { "item-produced", "iron-bloom", 1 }, requires = { "first-copper" } },
  M{ id = "first-wrought-iron", era = "iron", title = "Wrought iron",
     hint = "A forge with your bronze anvil hammers the slag out of the bloom.",
     done = { "item-produced", "iron-plate", 1 }, requires = { "first-bloom", "first-anvil" } },
  M{ id = "first-brass", era = "iron", title = "Brass",
     hint = "Lead-zinc veins give zinc ore. Heat it with copper and charcoal to make brass.",
     done = { "item-produced", "brass-plate", 1 }, requires = { "first-copper" } },
  M{ id = "first-iron-tools", era = "iron", title = "Iron tools",
     hint = "Forge an iron tool set: the start of real machines.",
     done = { "item-produced", "iron-tool-set", 1 }, requires = { "first-wrought-iron" } },

  ------------------------------------------------------------------ 5. Mechanical Age
  M{ id = "first-lathe", era = "mechanical", title = "Turning",
     hint = "A treadle lathe turns bronze bushings and cuts screws.",
     done = { "entity-built", "treadle-lathe", 1 }, requires = { "first-iron-tools" } },
  M{ id = "first-gear", era = "mechanical", title = "Gears",
     hint = "At a machinist's bench, cut and file iron into gear wheels.",
     done = { "item-produced", "iron-gear-wheel", 1 }, requires = { "first-iron-tools" } },
  M{ id = "first-lens", era = "mechanical", title = "Lenses",
     hint = "Grind glass into lenses for instruments.",
     done = { "item-produced", "lens", 1 }, requires = { "first-glass", "first-gear" } },
  M{ id = "first-instrument", era = "mechanical", title = "Precision instruments",
     hint = "Brass, a lens, gears and screws make an instrument, then a machinist's tool set.",
     done = { "item-produced", "machinist-tool-set", 1 }, requires = { "first-lens", "first-brass", "first-lathe" } },

  ------------------------------------------------------------------ 6. Early Industrial
  M{ id = "first-coke", era = "early-industrial", title = "Coke",
     hint = "Fire bricks need quartz. Build a coke oven and bake coal into coke.",
     done = { "item-produced", "coke", 1 }, requires = { "first-kiln" } },
  M{ id = "first-pig-iron", era = "early-industrial", title = "Molten iron",
     hint = "A blast furnace with coke and limestone flux finally melts iron.",
     done = { "item-produced", "pig-iron", 1 }, requires = { "first-coke", "first-wrought-iron" } },
  M{ id = "first-cylinder", era = "early-industrial", title = "A true cylinder",
     hint = "Cast a cylinder blank in a cupola furnace, then bore it true in a boring mill.",
     done = { "item-produced", "steam-cylinder", 1 }, requires = { "first-pig-iron", "first-instrument" } },
  M{ id = "first-screw-lathe", era = "early-industrial", title = "Standard screws",
     hint = "Build a screw-cutting lathe. It makes identical precision screws.",
     done = { "entity-built", "screw-cutting-lathe", 1 }, requires = { "first-cylinder" } },
  M{ id = "first-drill", era = "early-industrial", title = "Mechanical mining",
     hint = "A steam-cylinder drill ends hand mining.",
     done = { "entity-built", "burner-mining-drill", 1 }, requires = { "first-screw-lathe" } },
  M{ id = "first-belt", era = "early-industrial", title = "Conveyors",
     hint = "Cloth, gears and iron make the first belts.",
     done = { "entity-built", "transport-belt", 10 }, requires = { "first-gear" } },
  M{ id = "first-research", era = "early-industrial", title = "Natural philosophy",
     hint = "Build a study and make automation science packs to research improvements.",
     done = { "item-produced", "automation-science-pack", 1 }, requires = { "first-instrument" } },

  ------------------------------------------------------------------ 7. Industrial
  M{ id = "first-power", era = "industrial", title = "Electricity",
     hint = "A boiler and a steam engine with dynamo windings power an electric network.",
     done = { "entity-built", "steam-engine", 1 }, requires = { "first-screw-lathe" } },
  M{ id = "first-machine-shop", era = "industrial", title = "The machine shop",
     hint = "Relays, a cast frame and precision screws make the first assembling machine.",
     done = { "entity-built", "assembling-machine-1", 1 }, requires = { "first-power" } },
  M{ id = "first-steel", era = "industrial", title = "Cheap steel",
     hint = "Blow air through pig iron in a Bessemer converter.",
     done = { "item-produced", "steel-plate", 1 }, requires = { "first-power", "first-pig-iron" } },
  M{ id = "first-oil", era = "industrial", title = "Oil",
     hint = "Pumpjacks and a refinery turn crude oil into fuel and chemicals.",
     done = { "item-produced", "petroleum-gas", 100 }, requires = { "first-steel" } },
  M{ id = "first-rail", era = "industrial", title = "Railways",
     hint = "Steel rails on gravel, and a steam locomotive.",
     done = { "entity-built", "locomotive", 1 }, requires = { "first-steel" } },

  ------------------------------------------------------------------ 8. Electronics
  M{ id = "first-valve", era = "electronics", title = "The valve",
     hint = "A vacuum tube controls current with no moving parts.",
     done = { "item-produced", "vacuum-tube", 1 }, requires = { "first-machine-shop" } },
  M{ id = "first-circuit", era = "electronics", title = "Electronic circuits",
     hint = "Valves, wire and solder make electronic circuits.",
     done = { "item-produced", "electronic-circuit", 1 }, requires = { "first-valve" } },
  M{ id = "first-transistor", era = "electronics", title = "The transistor",
     hint = "Reduce quartz to silicon in an electric arc furnace.",
     done = { "item-produced", "transistor", 1 }, requires = { "first-circuit" } },
  M{ id = "first-chip", era = "electronics", title = "Integrated circuits",
     hint = "Etched silicon wafers become processing units.",
     done = { "item-produced", "processing-unit", 1 }, requires = { "first-transistor", "first-oil" } },

  ------------------------------------------------------------------ 9. Modern to Space Age
  M{ id = "first-aluminium", era = "modern", title = "Aluminium",
     hint = "Bauxite becomes alumina, then aluminium by electrolysis.",
     done = { "item-produced", "aluminium-plate", 1 }, requires = { "first-chip" } },
  M{ id = "first-rocket", era = "modern", title = "To orbit",
     hint = "Build a rocket silo and launch a rocket.",
     done = { "item-produced", "rocket-part", 1 }, requires = { "first-aluminium" } },
  M{ id = "first-platform", era = "modern", title = "A space platform",
     hint = "Make a space platform starter pack and launch it. Every planet is open to a platform. Asteroids will test your defences.",
     done = { "item-produced", "space-platform-starter-pack", 1 }, requires = { "first-rocket" } },
}
