local start = require("script.start")
local help = require("script.help")
local world = require("script.world")

script.on_init(function()
  start.empty_start()
  start.no_enemies_everywhere()
  start.grant_all_forces()
  world.init_new_game()
  help.init()
end)

script.on_configuration_changed(function()
  start.no_enemies_everywhere()
  start.grant_all_forces()
  world.populate_existing()
  help.init()
end)

script.on_event(defines.events.on_force_created, function(e)
  start.grant_foundations(e.force)
end)

script.on_event(defines.events.on_chunk_generated, function(e)
  start.clear_enemies(e.surface, e.area)
  world.populate_chunk(e.surface, e.area)
end)

script.on_event(defines.events.on_player_created, function(e)
  help.ensure_button(game.get_player(e.player_index))
end)

script.on_event(defines.events.on_gui_click, function(e)
  if e.element and e.element.valid and e.element.name == help.BUTTON then
    help.toggle(game.get_player(e.player_index))
  end
end)

local function built(e)
  local entity = e.entity
  help.on_built(entity)
  world.set_excavator_recipe(entity, e.player_index and game.get_player(e.player_index))
end
script.on_event({
  defines.events.on_built_entity,
  defines.events.on_robot_built_entity,
  defines.events.on_space_platform_built_entity,
  defines.events.script_raised_built,
}, built)

-- The excavator's output follows the ground; undo any manual recipe change.
script.on_event(defines.events.on_gui_closed, function(e)
  if e.entity then world.set_excavator_recipe(e.entity, game.get_player(e.player_index)) end
end)
script.on_event(defines.events.on_entity_settings_pasted, function(e)
  world.set_excavator_recipe(e.destination, game.get_player(e.player_index))
end)

local function mined(e) world.on_mined(e.entity) end
script.on_event({ defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity }, mined)

script.on_nth_tick(300, help.check_all)
script.on_nth_tick(600, world.process_regrowth)
