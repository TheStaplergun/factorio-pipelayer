local empty_sprite = {
  filename = "__core__/graphics/empty.png",
  width = 1,
  height = 1,
  frame_count = 1,
}

local ug = data.raw["pipe-to-ground"]["pipe-to-ground"]

local connector = {
  type = "storage-tank",
  name = "pipelayer-connector",
  icons = {
    {
      icon = ug.icon,
      icon_size = ug.icon_size,
    },
    overlay_icon,
  },
  flags = ug.flags,
  minable = {mining_time = 1.5, result = "pipelayer-connector"},
  max_health = ug.max_health,
  corpse = ug.corpse,
  resistances = ug.resistances,
  collision_box = ug.collision_box,
  selection_box = ug.selection_box,
  fluid_box = {
    base_area = settings.startup["pipelayer-connector-capacity"].value / 100,
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
      { position = {0, -1} },
    }
  },
  window_bounding_box = {{0, 0}, {0, 0}},
  pictures = {
    picture = {
      north = {
        filename = "__base__/graphics/entity/pipe-to-ground/pipe-to-ground-up.png",
        priority = "high",
        width = 64,
        height = 64, --, shift = {0.10, -0.04}
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe-to-ground/hr-pipe-to-ground-up.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          scale = 0.5
        }
      },
      east = {
        filename = "__base__/graphics/entity/pipe-to-ground/pipe-to-ground-right.png",
        priority = "high",
        width = 64,
        height = 64, --, shift = {0.1, 0.1}
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe-to-ground/hr-pipe-to-ground-right.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          scale = 0.5
        }
      },
      south = {
        filename = "__base__/graphics/entity/pipe-to-ground/pipe-to-ground-down.png",
        priority = "high",
        width = 64,
        height = 64, --, shift = {0.05, 0}
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe-to-ground/hr-pipe-to-ground-down.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          scale = 0.5
        }
      },
      west = {
        filename = "__base__/graphics/entity/pipe-to-ground/pipe-to-ground-left.png",
        priority = "high",
        width = 64,
        height = 64, --, shift = {-0.12, 0.1}
        hr_version =
        {
          filename = "__base__/graphics/entity/pipe-to-ground/hr-pipe-to-ground-left.png",
          priority = "extra-high",
          width = 128,
          height = 128,
          scale = 0.5
        }
      },
    },
    window_background = empty_sprite,
    fluid_background = empty_sprite,
    flow_sprite = empty_sprite,
    gas_flow = empty_sprite,
  },
  flow_length_in_ticks = 1,
}

local bpproxy_output_connector = util.table.deepcopy(connector)
bpproxy_output_connector.name = "pipelayer-output-connector"
bpproxy_output_connector.flags = {"player-creation"}
bpproxy_output_connector.placeable_by = {{item="pipelayer-connector", count=1}}

data:extend{
  connector,
  bpproxy_output_connector,
}