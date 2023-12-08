--      ██████╗  █████╗ ███████╗████████╗███████╗██╗
--      ██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██╔════╝██║
--      ██████╔╝███████║███████╗   ██║   █████╗  ██║
--      ██╔═══╝ ██╔══██║╚════██║   ██║   ██╔══╝  ██║
--      ██║     ██║  ██║███████║   ██║   ███████╗███████╗
--      ╚═╝     ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local gears = require("gears")

local pastel = {}


-- ===================================================================
-- Pastel setup
-- ===================================================================

scratch_tags_n = 1
tag_names = { "code", "www", "msg", "msg-private", "scratch1" }

pastel.initialize = function()
   -- Import components
   require("components.pastel.wallpaper")
   require("components.exit-screen")
   require("components.volume-adjust")
   require("components.brightness-adjust")

   -- Import panels
   local left_panel = require("components.pastel.left-panel")
   local top_panel = require("components.pastel.top-panel")

   -- Set up each screen (add tags & panels)
   awful.screen.connect_for_each_screen(function(s)
      for i = 1, 5, 1 do
         awful.tag.add(tag_names[i], {
            icon = gears.filesystem.get_configuration_dir() .. "/icons/tags/pastel/" .. tag_names[i] .. ".png",
            icon_only = true,
            layout = awful.layout.suit.tile,
            screen = s,
            selected = i == 1
         })
      end

      left_panel.create(s)
      -- Add the top panel to every screen
      top_panel.create(s)
   end)
end

return pastel
