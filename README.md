# Stone Age to Space Age (factorio-irl)

A Factorio 2.1 + Space Age overhaul: start with nothing, and craft your way through humanity's real technological history to the Space Age.

## Status
**Phases 1 to 6 built; ready for the first playtest.** See `docs/build-notes.md` for Phases 3 to 6 and how to run the offline checks (`tools/check.lua`).

Layout:
- `data/master/` holds the master data tables, the single source of truth for all content (see the Phase 1 docs).
- `data.lua` runs `prototypes/generate.lua`, which builds era menu groups, recipe categories, the biomass fuel category, new items, stations, recipes and upgrade research from the master data.
- `data-final-fixes.lua` runs `prototypes/rules.lua`, which:
  - reworks vanilla recipes in place
  - moves vanilla items into eras
  - limits the character to hand recipes and enables every recipe
  - strips recipe unlocks from research and grants planets and other unlocks at start
  - removes quality and all enemy spawning
- `control.lua` handles the empty start (no items, crash site or intro), the enemy backstop and the help panel. The help panel is the button at the top left that lists the next milestones. It never gives anything.

`prototypes/world.lua` and `script/world.lua` handle ore patches, pickables, regrowth and the excavator.

Install for testing: copy or symlink this folder into your Factorio `mods` folder as `factorio-irl`. It needs Factorio 2.1 with Space Age.

## Decisions so far
- All eras in full detail. Quality removed. Planets open once you can build a rocket and a platform.
- Hand mining until steam drills (Early Industrial). Mechanical power is on hold.
- No science packs until an upgrade needs one. All recipes enabled from the start.
- Mixed ore patches where ores really occur together. 10x richness. Pickables and trees regrow.
