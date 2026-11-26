# Open questions (end of Phase 1)

**Status: all 12 recommendations approved by Tom on 2026-11-25.** The data follows them.

## Decisions for Tom

1. **When does science start?** Your rule is no packs until an upgrade needs one. Proposal: the first pack (red) arrives in the Early Industrial era with a "study" as the first lab, and eras 1 to 5 have no research at all. Red researches crafting speed, running speed, reach and inventory. The alternative is an earlier pack around the Iron Age for hand-mining speed, which would make the long hand-mining stretch shorter. *Recommend: Early Industrial.*

2. **Ore pairs.** Mixed patches, each with one ore and two outputs:
   - **Tin-quartz vein** gives tin ore, plus quartz 50% of the time. Cassiterite really does form in quartz veins.
   - **Lead-zinc vein** gives lead ore, plus zinc ore 50% of the time. Galena and sphalerite occur together in most real deposits.
   - Limestone, sulfur and bauxite are single patches. Limestone with quartz was considered, but quartz in limestone is rare (chert), so it was left out.
   That makes 5 new patches producing 7 ores. *Recommend: as listed. The 50% second output is a tuning knob.*

3. **Mechanical Age without mechanical power.** Because water and wind power are on hold, foot- and hand-powered machines (treadle lathe, machinist's bench, boring mill) just run with no fuel. The blast furnace's blowing and the boring mill were water-powered in reality. This makes the Mechanical Age mostly a precision-parts era (gears, screws, lenses, instruments). *Recommend: accept for now, and revisit if you approve mechanical power later.*

4. **Fuel tiers (new mechanic, needs your OK).** Wood and sticks move to a new "biomass" fuel category. Fire pits, kilns, charcoal pits and boilers burn both biomass and normal fuel, but bellows furnaces, bloomeries, forges and blast furnaces burn only charcoal, coal or coke. This is what makes "charcoal plus bellows" a real gate. *Recommend: yes.*

5. **Muscle-powered stations run on their own.** A workbench, once fed, keeps crafting with nobody standing at it. Requiring the player to stand nearby would need extra scripting. *Recommend: accept, since they are slow (speed 0.5).*

6. **Leather.** Real bellows used leather. With no animals, they use cloth. *Recommend: accept.*

7. **Burner inserter.** It has no clean historical match in 1700 to 1850. It stands in for the mechanical feeders of automated mills, made from iron, a gear and a spring. *Recommend: accept.*

8. **Relays (an item not in the plan).** Vanilla's Industrial-era machines (inserters, assemblers, chemical plants, pumpjacks) all need electronic circuits, which would drag electronics back into the 1800s. An electromechanical **relay** (1835) replaces circuits in those recipes. *Recommend: yes.*

9. **Vanilla stone furnace as the puddling furnace.** It keeps its name and look, but now arrives in the Early Industrial era and turns pig iron into iron plate. The vanilla `iron-plate` recipe now takes pig iron. *Recommend: accept, or rename it to "Puddling furnace" in Phase 2.*

10. **Abstracted chemistry.** Water is left out of mortar and concrete, caustic soda out of alumina, and sulfuric acid stands in for hydrofluoric acid when etching wafers. *Recommend: accept (plan pillar 4).*

11. **Sulfur placement.** Nauvis has no volcanic ground, so sulfur patches go on red desert. *Recommend: accept.*

12. **Tools are consumed into stations.** Flint, bronze, iron, machinist and machine tool sets are ingredients of stations, not durable items. That avoids a tool-wear mechanic. *Recommend: accept.*

## Raised during the build

13. **Eggs without enemies.** Space Age only gets pentapod eggs and biter spawners from enemies, so with no enemies the whole Gleba line would be unreachable. *Built with the recommendation:* harmless pentapod egg nests on Gleba (regrow), and rare dormant biter nests on Nauvis that mine into a captive spawner. *Waiting on Tom's decision.*

## Technical notes for Phase 2 (no decision needed)

- The 2.1 prototype docs confirm `RecipePrototype.categories` is an **array**, so one recipe can belong to several stations. The data relies on this. The docs site's front page says 2.0.76 while the prototype pages say 2.1.25; the 2.1 fields will be re-checked when the generator is written.
- Character crafting is limited to the `hand` category (`CharacterPrototype.crafting_categories`).
- Planets: unlock every space location and space platforms at game start, and remove discovery techs (Tom, Q4).
- Quality: drop the quality mod dependency and quality research entirely (Tom, Q5).
- Pickable regrowth and tree regrowth need a script (Phase 3).
- Excavator: one entity, recipe set by script from the tile under it. The Nauvis tile names in `resources.lua` must be verified.
- `beyond` era is an empty placeholder.
