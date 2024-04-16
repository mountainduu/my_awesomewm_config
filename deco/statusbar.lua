-- Standard awesome library
local gears = require("gears")
local awful     = require("awful")
local lain  = require("lain")


-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Common Functional Decoration
local deco = {
  wallpaper = require("deco.wallpaper"),
  taglist   = require("deco.taglist"),
  tasklist  = require("deco.tasklist"),
  separators = require("deco.separators"),
  colors = require("deco.colors")
}

local taglist_buttons  = deco.taglist()
local tasklist_buttons = deco.tasklist()

local _M = {}



local dir                                       = os.getenv("HOME") .. "/.config/awesome/deco/icons"

local icons = {}
icons.widget_ac                                 = dir .. "/ac.png"
icons.widget_battery                            = dir .. "/battery.png"
icons.widget_battery_low                        = dir .. "/battery_low.png"
icons.widget_battery_empty                      = dir .. "/battery_empty.png"
icons.widget_mem                                = dir .. "/mem.png"
icons.widget_cpu                                = dir .. "/cpu.png"
icons.widget_temp                               = dir .. "/temp.png"
icons.widget_net                                = dir .. "/net.png"
icons.widget_vol                                = dir .. "/vol.png"
icons.widget_vol_low                            = dir .. "/vol_low.png"
icons.widget_vol_no                             = dir .. "/vol_no.png"
icons.widget_vol_mute                           = dir .. "/vol_mute.png"
icons.widget_sysload                            = dir .. "/taskv1.png"


local font = "Terminus 9"

local markup = lain.util.markup
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- seperators
local separators = deco.separators
local bs_am = separators.backslash(deco.colors.accent, "alpha")
local bs_ma = separators.backslash("alpha", deco.colors.accent)
local fs_am = separators.forwardslash(deco.colors.accent, "alpha")
local fs_ma = separators.forwardslash("alpha", deco.colors.accent)


-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- MEM
local memicon = wibox.widget.imagebox(icons.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(font, " " .. mem_now.used .. "MB "))
    end
})


-- CPU
local cpuicon = wibox.widget.imagebox(icons.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(font, " " .. cpu_now.usage .. "% "))
    end
})


-- Coretemp
local tempicon = wibox.widget.imagebox(icons.widget_temp)
local cpu_temp = wibox.widget.textbox()
--- hwmon3 for pc, hwmon5 for laptop
awful.widget.watch('bash -c "cat /sys/class/hwmon/hwmon5/temp1_input"', 5, function(widget, stdout)
	stdout = stdout / 1000
	cpu_temp:set_markup_silently(markup.font(font, " " .. stdout .. "°C"))
	end
)
--[[


local handle = io.popen("cat /sys/class/hwmon/hwmon3/temp1_input")
local coretemp = handle:read("*a") / 1000
handle:close()
local temp V= lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font(font, " " .. coretemp .. "°C "))
    end
})
--]]
-- System Load
local sysloadicon = wibox.widget.imagebox(icons.widget_sysload)
local sysload = lain.widget.sysload({
	settings = function()
		widget:set_markup(markup.font(font, " " .. load_1))
	end
})
	


-- ALSA volume
local volume 
local volicon = wibox.widget.imagebox(icons.widget_vol)
volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(icons.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(icons.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            volicon:set_image(icons.widget_vol_low)
        else
            volicon:set_image(icons.widget_vol)
        end

        widget:set_markup(markup.font(font, " " .. volume_now.level .. "% "))
    end
})


local volume_popup = awful.popup {
	ontop = false,
	visible = false,
	shape = function(cr, width, height)
		gears.shape.rectangle(cr, width, height)
	end,
	border_width = 1,
	border_color = deco.colors.accent,
	maximun_width = 400,
	widget = {}
}

local volume_popup_items = {
	{ name = "Output", var = volume_popup_output },
	{ name = "Mixer", var = volume_popup_mixer }
}

function open_volume_popup()
	print("test")
	if volume_popup.visible then
		volume_popup.visible = not volume_popup.visible
		print("test2")
	else
		volume_popup:move_next_to(mouse.current_widget_geometry)
	end
end


volicon:buttons(
	awful.util.table.join(
		awful.button({}, 1, open_volume_popup()
		)
	)
)

local rows = { layout  = wibox.layout.fixed.vertical }

for _, item in ipairs(volume_popup_items) do
	local row = wibox.widget {
		text = item.name,
		widget = wibox.widget.textbox,
		var = item.var
	}
	print(row)
	table.insert(rows, row)
end

volume_popup:setup(rows)


-- Net
local neticon = wibox.widget.imagebox(icons.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.font(font,
                          markup("#7AC82E", " " .. string.format("%06.1f", net_now.received))
                          .. " " ..
                          markup("#46A8C3", " " .. string.format("%06.1f", net_now.sent) .. " ")))
    end
})

-- Battery
local baticon = wibox.widget.imagebox(icons.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if bat_now.status and bat_now.status ~= "N/A" then
            if bat_now.ac_status == 1 then
                baticon:set_image(icons.widget_ac)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                baticon:set_image(icons.widget_battery_empty)
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                baticon:set_image(icons.widget_battery_low)
            else
                baticon:set_image(icons.widget_battery)
            end
            widget:set_markup(markup.font(font, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(markup.font, " AC "))
            baticon:set_image(icons.widget_ac)
        end
    end
})

-- todo: typing speed, music (through cmus), intergrated or dedicated gpu, gpu temps, gpu usage, fan speed, hard drive usage or transfers

awful.screen.connect_for_each_screen(function(s)
  -- Wallpaper
  set_random_wallpaper(s)
  -- Create a promptbox for each screen
  s.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  s.mylayoutbox = awful.widget.layoutbox(s)
  s.mylayoutbox:buttons(gears.table.join(
    awful.button({ }, 1, function () awful.layout.inc( 1) end),
    awful.button({ }, 3, function () awful.layout.inc(-1) end),
    awful.button({ }, 4, function () awful.layout.inc( 1) end),
    awful.button({ }, 5, function () awful.layout.inc(-1) end)
  ))

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a tasklist widget
  s.mytasklist = awful.widget.tasklist {
    screen  = s,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons
  }

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      RC.launcher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      --music here
      baticon,
      bat.widget,
      fs_ma,
      wibox.container.background(memicon, deco.colors.accent),
      wibox.container.background(mem.widget, deco.colors.accent),
      bs_am,
      cpuicon,
      cpu.widget,
      fs_ma,
      wibox.container.background(tempicon, deco.colors.accent),
      wibox.container.background(cpu_temp, deco.colors.accent),
      bs_am,
      neticon,
      net.widget,
      fs_ma,
      wibox.container.background(volicon, deco.colors.accent),
      wibox.container.background(volume.widget, deco.colors.accent),
      bs_am,
      sysloadicon,
      sysload.widget,

      --mykeyboardlayout,
      fs_ma,
      wibox.container.background(mytextclock, deco.colors.accent),
      bs_am,
      wibox.widget.systray(),
      s.mylayoutbox
    },
  }
end)
-- }}}

