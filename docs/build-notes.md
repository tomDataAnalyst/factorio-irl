# Build notes: Phases 3 to 6

## Phase 3: World
- **New ore patches** (`prototypes/world.lua`): tin-quartz vein (tin, plus quartz half the time), lead-zinc vein (lead, plus zinc half the time), limestone, sulfur deposit and bauxite. They use the official `resource-autoplace` library, and tin-quartz and limestone also appear in the starting area. Each has a map-settings slider.
- **Richness:** every Nauvis ore patch, vanilla and new, is multiplied by 10 (`resources.lua: richness_multiplier`).
- **Pickables:** stones, sticks, flint, fibre grass, clay banks, sand piles and copper, tin and iron nodules. They are small tinted copies of vanilla rocks and trees. Script places them as each chunk generates, using the rules in `resources.lua` (`spawn`): which tiles, near water, near trees, or near a given ore.
- **Regrowth:** a picked pickable comes back at the same spot after 10 minutes, and a chopped Nauvis tree after 30. Both are tunable in `resources.lua`.
- **Excavator:** a burner machine with the burner drill's look. When built, it sets its own output from the tile under it: sand on sand, clay on grass or dirt, gravel on red desert. Changing the recipe by hand or by paste is undone. On other ground it says "Nothing to dig here".

## Phase 4: Content and reachability
- `tools/check.lua` loads the **real Factorio 2.1.25 data** (core, base, elevated-rails, recycler, space-age, from a checkout of `wube/factorio-data`), runs this mod through all three data stages, and checks the result offline:
  - Every reference resolves: recipe categories, ingredients and results, item subgroups, place results, fuel categories, technology prerequisites, autoplace entries, and technology references in tips and achievements.
  - No recipe uses fields that 2.1 removed (`category`, product `probability`, item `fuel_category`).
  - Only hand recipes are craftable by the character, and no technology unlocks recipes, quality or items.
  - **Era order:** no recipe uses an ingredient from a later era.
  - **Reachability:** starting from an empty inventory, every enabled recipe's products can be reached. That covers the eras on Nauvis, then the rocket and platform, then every Space Age planet.
  - Every station can be built and every milestone can be completed.
- The current result is "ALL CHECKS PASSED": 373 items and fluids reachable, and the planets open after 289 of them.

## Phase 5: Vanilla and Space Age
- The vanilla intermediates are reworked in place under their own names (`recipes.lua` rows with `vanilla = true`). Space Age recipes and the productivity research that use them still connect, and the check above confirms it.
- **Quality:** Space Age 2.1 only recommends quality, so `info.json` declares `! quality` and the quality mod is switched off entirely. Leftover quality unlocks are also stripped as a backstop. The recycler stays, because Fulgora needs it for scrap.
- **Planets:** every space location and platform unlock is granted at game start through a hidden "Foundations" technology. A rocket and a platform are all you need (Tom, Q4).
- **Asteroid defence:** gun turrets and ammunition are reachable. Ammunition is brass, lead and sulfur. Weapon damage and shooting-speed research are kept.
- **Eggs without enemies:** Space Age only gets pentapod eggs and biter spawners from enemies. Two harmless sources replace them:
  - **Pentapod egg nests** on Gleba give 3 eggs each and regrow.
  - **Rare dormant biter nests** on Nauvis, more than 400 tiles out, mine into a captive biter spawner.
  This option is waiting on Tom's decision.

## Phase 6: Checks, then playtest
- Run the checks: `lua5.2 tools/check.lua <path to factorio-data> .`. This needs a Lua 5.2+ interpreter and a clone of https://github.com/wube/factorio-data at the game version you play.
- **Not checked offline:** anything that needs the running game.
  - Graphics are never opened, so a bad sprite field only shows in game. The risky ones are the stations converted from furnaces and drills into assemblers, and the scaled pickables.
  - The freeplay remote calls (empty start) are guarded, so a renamed function is skipped rather than crashing.
  - Spawn density and regrowth timing need a feel test.
