-- Eras: the timeline that organizes the crafting menu (plan section 2.6) and
-- the help system. Each era becomes one item group; each entry in `subgroups`
-- becomes an item subgroup named "<era>-<subgroup>", in this order.
--
-- `period` is flavor text for the help panel and design reference only.

local subgroups = { "raw", "materials", "parts", "tools", "stations", "logistics", "science" }

return {
  { name = "stone",            order = "a", period = "before 4000 BC",  icon_from = "stone",                    subgroups = subgroups },
  { name = "clay",             order = "b", period = "6000 - 3000 BC",  icon_from = "stone-brick",              subgroups = subgroups },
  { name = "bronze",           order = "c", period = "3300 - 1200 BC",  icon_from = "copper-plate",             subgroups = subgroups },
  { name = "iron",             order = "d", period = "1200 BC - AD 1400", icon_from = "iron-plate",             subgroups = subgroups },
  { name = "mechanical",       order = "e", period = "1400 - 1750",     icon_from = "iron-gear-wheel",          subgroups = subgroups },
  { name = "early-industrial", order = "f", period = "1700 - 1850",     icon_from = "burner-mining-drill",      subgroups = subgroups },
  { name = "industrial",       order = "g", period = "1850 - 1910",     icon_from = "steel-plate",              subgroups = subgroups },
  { name = "electronics",      order = "h", period = "1904 - 1970",     icon_from = "electronic-circuit",       subgroups = subgroups },
  { name = "modern",           order = "i", period = "1950 - Space Age", icon_from = "rocket-silo",             subgroups = subgroups },
  -- Era 10 "Beyond Space Age" is out of scope for the first version (plan section 5).
  { name = "beyond",           order = "j", period = "future",          icon_from = "space-science-pack",       subgroups = {}, placeholder = true },
}
