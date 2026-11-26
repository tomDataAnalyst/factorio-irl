# Era summaries

Phase 1 design. Every row lives in `data/master/*.lua`; this page is the readable overview.
Counts: 134 items (about 60 vanilla items moved into eras), 106 recipes, 17 new stations, 42 milestones.
A reachability check from an empty inventory passes: every listed item can be made, with no loops that can't be bootstrapped.

Power spine note: mechanical power is on hold (Tom, Q7). Hand- and foot-powered machines (workbench, treadle lathe, machinist's bench, boring mill, study) use "void" energy, meaning they run on muscle with no fuel. Fire stations burn fuel. Electricity starts in the Industrial era.

## 1. Stone Age (before 4000 BC)
You start with nothing. Pick up stones, sticks, flint, plant fibre and clay from the ground, and chop trees for wood. By hand only: knap flint into flakes, twist fibre into cordage, and make a flint axe, flint knife and stone hammer. Those tools plus wood make the **workbench**, and stones around sticks make a **pit fire**. The pit fire slowly fires clay into bricks.
**Earned milestone:** 20 bricks, which lead into the first kiln.

## 2. Clay and Fire (6000 to 3000 BC)
The **pottery kiln** (bricks, clay, stone) fires bricks faster, burns limestone into quicklime, and makes crucibles. Quicklime plus sand gives mortar. The **charcoal pit** turns wood into charcoal, the first high-heat fuel. Plant fibre is woven into cloth.
**Earned milestone:** the first kiln (end of the Stone Age), then charcoal.

## 3. Copper and Bronze (3300 to 1200 BC)
Cloth, planks and cordage make **bellows**. Bellows, crucibles, bricks and mortar make the **bellows furnace**, which only burns charcoal or better. Wood is not hot enough, and that is the real gate. It smelts copper, tin and lead, alloys bronze (3 copper to 1 tin), melts glass, and casts a bronze anvil and bronze tools.
Tin comes from tin-quartz veins, and copper and tin also lie as surface nodules.

## 4. Iron Age (1200 BC to AD 1400)
The **bloomery** reduces iron ore into a spongy bloom, at 2 ore per bloom, because it was a wasteful process. The **forge** (bellows, bronze anvil, bronze tools) hammers blooms into wrought iron (`iron-plate`), and makes iron rods, iron chests and an iron tool set. Brass is made by cementation: copper heated with zinc ore and charcoal.

## 5. Mechanical Age (1400 to 1750)
This is the precision era. The **treadle lathe** turns bronze bushings and cuts screws by hand. The **machinist's bench** files gears (`iron-gear-wheel`), grinds lenses, and builds brass precision instruments and the machinist's tool set. Springs are forged.
This era is thinner than the plan imagined, because water wheels and windmills are on hold (see open question 3).

## 6. Early Industrial (1700 to 1850)
Coal is baked into **coke**. Fire bricks (clay and quartz) build the **coke oven** and the **blast furnace**, which melts iron ore with coke and limestone flux into pig iron. The stone furnace now plays the **puddling furnace**, turning pig iron into iron plate at twice the bloomery's ore efficiency. The **cupola furnace** casts machine frames, pipe and cylinder blanks. The **boring mill** bores those into true steam cylinders, the gate for every steam machine. The **screw-cutting lathe** makes precision screws.
Then come the first drills (Tom, Q6), the **excavator** for sand, clay and gravel, transport belts, burner inserters, the offshore pump, and the first research: the **study** with red science.

## 7. Industrial (1850 to 1910)
Electricity arrives: a boiler and a steam engine with dynamo windings, copper wire and poles. **Relays** stand in for circuits in this era's machines. `assembling-machine-1` is the electric machine shop, and it can automate all earlier workbench, fitting and turning recipes. The **Bessemer converter** makes cheap steel from pig iron. Also in this era: machine tool sets, engines, solder, Portland cement and concrete, electric drills and inserters, labs and green science, chemistry and oil, and steam railways.

## 8. Electronics (1904 to 1970)
Vacuum tubes give the first `electronic-circuit`. The electric arc furnace reduces quartz to silicon, which becomes transistors (`advanced-circuit`, plus a cheaper green circuit recipe) and etched silicon wafers (`processing-unit`). Lead-acid batteries, plastics, `assembling-machine-2` and blue science also arrive here. Measured against the plan's target, chips sit 7 eras deep.

## 9. Modern to Space Age (1950 onward)
Bauxite becomes alumina, then aluminium by electrolysis, which feeds `low-density-structure`. Ammunition uses brass cases, lead bullets and sulfur, for asteroid defence. Every other vanilla and Space Age item keeps its recipe until Phase 5. A rocket and a platform open every planet (Tom, Q4).

## 10. Beyond Space Age
Placeholder only, out of scope.
