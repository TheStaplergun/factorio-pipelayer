local Connector = require "Connector"
local Editor = require "Editor"
local Network = require "Network"
local Queue = require "lualib.Queue"
local version = require "lualib.version"

local M = {}

local all_migrations = {}

local function add_migration(migration)
  all_migrations[#all_migrations+1] = migration
end

function M.on_mod_version_changed(old)
  old = version.parse(old)
  for _, migration in ipairs(all_migrations) do
    if version.lt(old, migration.version) then
      log("running world migration "..migration.name)
      migration.task()
    end
  end
end

add_migration{
  name = "v0_2_0_migrate_globals",
  version = {0,2,0},
  task = function()
    global.editor = Editor.instance()
    global.editor.player_state = global.player_state or {}
    global.player_state = nil
    global.editor_surface = nil
  end,
}

add_migration{
  name = "v0_2_1_add_pipemarker_global",
  version = {0,2,1},
  task = function()
    global.players = global.players or {}
  end,
}

add_migration{
  name = "v0_2_1_add_network_absorb_work_queue",
  version = {0,2,1},
  task = function()
    global.absorb_queue = Queue.new()
    for _, network in pairs(global.all_networks) do
      network.graph = nil
    end
    Network.on_load()
  end,
}

local function resolve_duplicated_pipe(pipe, na, nb)
  local unit_number = pipe.unit_number
  log("pipe "..unit_number.." in network "..nb.id.." already seen in network "..na.id)
  local connector = Connector.for_below_unit_number(unit_number)
  na:remove_underground_pipe(pipe, true)
  nb:remove_underground_pipe(pipe, true)
  if na.id > nb.id then
    na:add_underground_pipe(pipe, connector and connector.entity)
  else
    nb:add_underground_pipe(pipe, connector and connector.entity)
  end
end

add_migration{
  name = "v0_2_5_clean_corrupted_networks",
  version = {0,2,5},
  task = function()
    local network_for_pipe = {}
    for network_id, network in pairs(global.all_networks) do
      for unit_number, pipe in pairs(network.pipes) do
        if pipe.valid then
          local previous_network = network_for_pipe[unit_number]
          if previous_network then
            resolve_duplicated_pipe(pipe, previous_network, network)
          end
          network_for_pipe[unit_number] = network
        else
          log("pipe "..unit_number.." in network "..network_id.." no longer valid")
          network.pipes[unit_number] = nil
        end
      end

      if not next(network.pipes) then
        network:destroy()
      end
    end
  end,
}

return M