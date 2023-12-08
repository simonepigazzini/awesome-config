--      ██╗     ██╗  ███████╗  ██╗   ██╗ ████████╗
--      ██║     ██║  ██╔════╝  ██║   ██║    ██╔══╝  
--      ██║     ██║  ██║       ████████║    ██║  
--      ██║     ██║  ██║ ███║  ██║   ██║    ██║
--      ██████║ ██║  ██████╔╝  ██║   ██║    ██║
--      ╚═════╝ ╚═╝  ╚═════╝   ╚═╝   ╚═╝    ╚═╝ 


-- ===================================================================
-- Initialization
-- ===================================================================


local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(0)
local offsety = dpi(300)
local screen = awful.screen.focused()
-- local icon_dir = gears.filesystem.get_configuration_dir() .. "/icons/volume/" .. beautiful.name .. "/"


-- ===================================================================
-- Appearance & Functionality
-- ===================================================================


local light_text = wibox.widget{
   align  = 'center',
   valign = 'center',
   font = 'SF Display Bold 20',
   widget = wibox.widget.textbox
}

-- create the light_adjust component
local light_adjust = wibox({
   screen = awful.screen.focused(),
   x = screen.geometry.width/2,
   y = (screen.geometry.height / 2) - (offsety / 2),
   width = dpi(80),
   height = offsety,
   shape = gears.shape.rounded_rect,
   visible = false,
   ontop = true
})

local light_bar = wibox.widget{
   widget = wibox.widget.progressbar,
   shape = gears.shape.rounded_bar,
   color = "#efefef",
   background_color = beautiful.bg_focus,
   max_value = 100,
   value = 0
}

light_adjust:setup {
   layout = wibox.layout.align.vertical,
   {
      wibox.container.margin(
         light_bar, dpi(14), dpi(20), dpi(20), dpi(20)
      ),
      forced_height = offsety * 0.75,
      direction = "east",
      layout = wibox.container.rotate
   },
   wibox.container.margin(
      light_text
   )
}

-- create a 4 second timer to hide the light adjust
-- component whenever the timer is started
local hide_light_adjust = gears.timer {
   timeout = 1.5,
   autostart = true,
   callback = function()
      light_adjust.visible = false
   end
}

get_current_brightness = function()
   awful.spawn.easy_async_with_shell(
      "cat /sys/class/backlight/intel_backlight/brightness",
      function(stdout)
         current_light_level = tonumber(stdout)
      end,
      false
   )
   awful.spawn.easy_async_with_shell(
      "cat /sys/class/backlight/intel_backlight/max_brightness",
      function(stdout)
         max_light_level = tonumber(stdout)
         frac_value = current_light_level/max_light_level*100
      end,
      false
   )
end

-- show light-adjust when "light_change" signal is emitted
awesome.connect_signal("light_change",
                       function(step)
                          if frac_value == nil then
                             get_current_brightness()
                          else
                             frac_value = frac_value+step
                          end
                          light_bar.value = frac_value
                          light_text.text = string.format("%.0f", frac_value) .. "%"

                          -- make light_adjust component visible
                          if light_adjust.visible then
                             hide_light_adjust:again()
                          else
                             light_adjust.visible = true
                             hide_light_adjust:start()
                          end
                       end
)
