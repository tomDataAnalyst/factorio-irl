# Stone Age to Space Age (factorio-irl)

A Factorio 2.1 + Space Age overhaul: start with nothing, and craft your way through humanity's real technological history to the Space Age.

## Status
**Phase 1: design data.** No gameplay code yet.

- `data/master/` holds the master data tables, the single source of truth for all content:
  - `eras.lua`: era list and menu groups
  - `resources.lua`: pickables, ore patches (10x richness), trees, excavator tile rules
  - `items.lua`: new items, and vanilla items placed into eras
  - `stations.lua`: crafting stations and their recipe categories
  - `recipes.lua`: every new or reworked recipe, with a real-world note
  - `milestones.lua`: help-system milestones
  - `research.lua`: science packs and upgrade research (proposal)
- `docs/eras.md`: a short summary of each era
- `docs/open-questions.md`: decisions needed before Phase 2

## Decisions so far
- All eras in full detail. Quality removed. Planets open once you can build a rocket and a platform.
- Hand mining until steam drills (Early Industrial). Mechanical power is on hold.
- No science packs until an upgrade needs one. All recipes enabled from the start.
- Mixed ore patches where ores really occur together. 10x richness. Pickables and trees regrow.
