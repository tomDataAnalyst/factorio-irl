local start = require("script.start")
local help = require("script.help")

script.on_init(function()
  start.empty_start()
  start.no_enemies_everywhere()
  start.grant_all_forces()
  help.init()
end)

script.on_configuration_changed(function()
  start.no_enemies_everywhere()
  start.grant_all_forces()
  help.init()
end)

script.on_event(defines.events.on_force_created, function(e)
  start.grant_foundations(e.force)
end)

script.on_event(defines.events.on_chunk_generated, function(e)
  start.clear_enemies(e.surface, e.area)
end)

script.on_event(defines.events.on_player_created, function(e)
  help.ensure_button(game.get_player(e.player_index))
end)

script.on_event(defines.events.on_gui_click, function(e)
  if e.element and e.element.valid and e.element.name == help.BUTTON then
    help.toggle(game.get_player(e.player_index))
  end
end)

local function built(e) help.on_built(e.entity) end
script.on_event({
  defines.events.on_built_entity,
  defines.events.on_robot_built_entity,
  defines.events.on_space_platform_built_entity,
  defines.events.script_raised_built,
}, built)

-- Production-based milestones: check every 5 seconds.
script.on_nth_tick(300, help.check_all)
