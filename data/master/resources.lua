-- Resources: everything the world gives the player (plan section 3).
--
-- method = "pickable"   small entity scattered on the ground, picked by hand.
--                       Regrows over time (Tom, Q11). `near` says where it spawns.
-- method = "ore"        map-generated ore patch. Hand-minable from the start;
--                       drills arrive in the Early Industrial era (Tom, Q6).
--                       `results` with two entries = one mixed patch with two
--                       outputs (Tom's ore-pairing answer).
-- method = "tree"       vanilla trees, which regrow (Tom, Q11).
-- method = "excavator"  dig-anywhere output chosen by the tile under the excavator.
--
-- richness: multiplier on vanilla-like richness. Global start is 10x (Tom, Q10).
-- tint: {r, g, b} 0-1, applied over the reused vanilla graphics in `entity_from`.

local RICHNESS = 10

return {
  richness_multiplier = RICHNESS,

  ---------------------------------------------------------------------------
  -- Pickables (Stone Age onward)
  ---------------------------------------------------------------------------
  { name = "loose-stones",    method = "pickable", results = { { "stone", 2 } },          entity_from = "big-rock",       tint = { 0.8, 0.8, 0.8 },
    near = "everywhere except water; denser on red-desert", mining_time = 0.5 },
  { name = "fallen-sticks",   method = "pickable", results = { { "stick", 3 } },          entity_from = "dead-grey-trunk", tint = { 0.7, 0.55, 0.4 },
    near = "under and around trees", mining_time = 0.3 },
  { name = "flint-nodules",   method = "pickable", results = { { "flint", 1 } },          entity_from = "sand-rock-big",  tint = { 0.35, 0.35, 0.4 },
    near = "near stone patches and on red-desert", mining_time = 0.8 },
  { name = "fiber-grass",     method = "pickable", results = { { "plant-fiber", 3 } },    entity_from = "dry-hairy-tree", tint = { 0.6, 0.8, 0.3 },
    near = "grassland", mining_time = 0.3 },
  { name = "clay-bank",       method = "pickable", results = { { "clay", 2 } },           entity_from = "sand-rock-big",  tint = { 0.75, 0.5, 0.35 },
    near = "within a few tiles of water", mining_time = 0.6 },
  { name = "sand-pile",       method = "pickable", results = { { "sand", 2 } },           entity_from = "sand-rock-big",  tint = { 0.95, 0.85, 0.6 },
    near = "sand tiles and beaches", mining_time = 0.4 },
  { name = "copper-nodule",   method = "pickable", results = { { "copper-ore", 1 } },     entity_from = "sand-rock-big",  tint = { 0.85, 0.5, 0.3 },
    near = "around copper ore patches", mining_time = 0.8 },
  { name = "tin-nodule",      method = "pickable", results = { { "tin-ore", 1 } },        entity_from = "sand-rock-big",  tint = { 0.75, 0.75, 0.8 },
    near = "around tin-quartz patches", mining_time = 0.8 },
  { name = "iron-nodule",     method = "pickable", results = { { "iron-ore", 1 } },       entity_from = "sand-rock-big",  tint = { 0.5, 0.55, 0.65 },
    near = "around iron ore patches", mining_time = 0.8 },

  ---------------------------------------------------------------------------
  -- Trees (vanilla, regrowing)
  ---------------------------------------------------------------------------
  { name = "trees", method = "tree", results = { { "wood", 4 } }, note = "Vanilla trees. Add regrowth near existing trees (Phase 3, scripted)." },

  ---------------------------------------------------------------------------
  -- Ore patches. Vanilla ores keep their names and get the richness multiplier.
  ---------------------------------------------------------------------------
  { name = "iron-ore",   method = "ore", vanilla = true, results = { { "iron-ore", 1 } },   richness = RICHNESS },
  { name = "copper-ore", method = "ore", vanilla = true, results = { { "copper-ore", 1 } }, richness = RICHNESS },
  { name = "stone",      method = "ore", vanilla = true, results = { { "stone", 1 } },      richness = RICHNESS },
  { name = "coal",       method = "ore", vanilla = true, results = { { "coal", 1 } },       richness = RICHNESS },
  { name = "crude-oil",  method = "ore", vanilla = true, results = { { "crude-oil", 10, fluid = true } }, richness = RICHNESS },
  { name = "uranium-ore",method = "ore", vanilla = true, results = { { "uranium-ore", 1 } }, richness = RICHNESS },

  -- New ores. Mixed patches yield two products per mining cycle
  -- (MinableProperties.results, with probability on the second output).
  { name = "tin-quartz-vein", method = "ore", entity_from = "iron-ore", tint = { 0.85, 0.85, 0.9 }, richness = RICHNESS,
    results = { { "tin-ore", 1 }, { "quartz", 1, probability = 0.5 } },
    placement = "Medium patches, often near copper (bronze needs both early).",
    note = "Cassiterite forms in quartz veins (greisen), so tin and quartz come out together." },
  { name = "lead-zinc-vein", method = "ore", entity_from = "iron-ore", tint = { 0.55, 0.55, 0.65 }, richness = RICHNESS,
    results = { { "lead-ore", 1 }, { "zinc-ore", 1, probability = 0.5 } },
    placement = "Medium patches, further out than the starting ores.",
    note = "Galena (lead) and sphalerite (zinc) are found together in most of the world's lead-zinc deposits." },
  { name = "limestone", method = "ore", entity_from = "stone", tint = { 0.95, 0.93, 0.8 }, richness = RICHNESS,
    results = { { "limestone", 1 } },
    placement = "Large patches near the start; needed from the Clay era (lime) onward." },
  { name = "sulfur-deposit", method = "ore", entity_from = "stone", tint = { 0.95, 0.9, 0.2 }, richness = RICHNESS,
    results = { { "sulfur", 1 } },
    placement = "Small patches on red-desert. Nauvis has no volcanic tiles, so red-desert stands in.",
    note = "Native sulfur was mined directly (Sicily) long before it was made from petroleum. Yields the vanilla sulfur item." },
  { name = "bauxite", method = "ore", entity_from = "copper-ore", tint = { 0.8, 0.45, 0.3 }, richness = RICHNESS,
    results = { { "bauxite", 1 } },
    placement = "Medium patches far from the start; only needed in the Modern era (aluminium)." },

  ---------------------------------------------------------------------------
  -- Excavator tile rules (Early Industrial). One excavator entity; script sets
  -- its recipe from the tile under it. Tile names to verify against 2.1 Nauvis.
  ---------------------------------------------------------------------------
  { name = "excavate-sand",   method = "excavator", tiles = { "sand-1", "sand-2", "sand-3" },                           results = { { "sand", 2 } } },
  { name = "excavate-clay",   method = "excavator", tiles = { "grass-1", "grass-2", "grass-3", "grass-4",
                                                              "dirt-1", "dirt-2", "dirt-3", "dirt-4", "dirt-5", "dirt-6", "dirt-7", "dry-dirt" },
                                                                                                                         results = { { "clay", 2 } } },
  { name = "excavate-gravel", method = "excavator", tiles = { "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3" }, results = { { "gravel", 2 } } },
}
