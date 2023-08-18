-- Standard awesome library
local gears = require("gears")
local beautiful = require("beautiful")

local wallpaper_dir = os.getenv("HOME") .. "/.config/awesome/deco/wallpapers/"

math.randomseed(os.time())
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--[[
function set_wallpaper(s)
  -- Wallpaper
  --pr)int(s.index)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end
--]]

function get_random_wallpaper(s)
	local wallpaper_array = {}
	local count = 0
	local screen_dir = wallpaper_dir .. s.index .. '/'
	for dir in io.popen('ls -pa ' .. screen_dir .. ' | grep -v /'):lines() do
		count = count + 1
		wallpaper_array[count] = dir
		print(dir)
	end

	--randomly generate file
	local random = math.random(1, count)
	wallpaper_id = s.index .. '/' .. wallpaper_array[random]
	local dir = wallpaper_dir .. wallpaper_id
	return dir
end

local next_wallpaper = nil

function set_random_wallpaper(s)
	if next_wallpaper == nil then
		next_wallpaper = get_random_wallpaper(s)
	end

	gears.wallpaper.maximized(get_random_wallpaper(s), s, true)
	next_wallpaper = get_random_wallpaper(s)
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_random_wallpaper)
