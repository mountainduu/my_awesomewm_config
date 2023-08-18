-- inspiration from https://github.com/lcpz/lain/blob/master/util/separators.lua


local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local separators = { height = beautiful.separators_height or 0, width = beautiful.separators_width or 9 }

--forwardslash

function separators.forwardslash(col1, col2)
    local widget = wibox.widget.base.make_widget()
    widget.col1 = col1
    widget.col2 = col2

    widget.fit = function(_, _, _)
        return separators.width, separators.height
    end

    widget.update = function(_, _)
        widget.col1 = col1
        widget.col2 = col2
        widget:emit_signal("widget::redraw_needed")
    end

    widget.draw = function(_, _, cr, width, height)
        if widget.col2 ~= "alpha" then
            cr:set_source_rgba(gears.color.parse_color(widget.col2))
            cr:new_path()
            cr:move_to(0, 0)
            cr:line_to(width, height)
            cr:line_to(width, 0)
            cr:close_path()
            cr:fill()

        end

        if widget.col1 ~= "alpha" then
            cr:set_source_rgba(gears.color.parse_color(widget.col1))
            cr:new_path()
            cr:move_to(0, 0)
            cr:line_to(width, height)
            cr:line_to(0, height)
            cr:close_path()
            cr:fill()
        end
   end

   return widget
   end

-- backslash
function separators.backslash(col1, col2)
    local widget = wibox.widget.base.make_widget()
    widget.col1 = col1
    widget.col2 = col2

    widget.fit = function(_, _, _)
        return separators.width, separators.height
    end

    widget.update = function(_, _)
        widget.col1 = col1
        widget.col2 = col2
        widget:emit_signal("widget::redraw_needed")
    end

    widget.draw = function(_, _, cr, width, height)
        if widget.col2 ~= "alpha" then
            cr:set_source_rgba(gears.color.parse_color(widget.col2))
            cr:new_path()
            cr:move_to(0, 0)
            cr:line_to(0, height)
            cr:line_to(width, 0)
            cr:close_path()
            cr:fill()

        end

        if widget.col1 ~= "alpha" then
            cr:set_source_rgba(gears.color.parse_color(widget.col1))
            cr:new_path()
            cr:move_to(0, 0)
            cr:line_to(width, 0)
            cr:line_to(0, height)
            cr:close_path()
            cr:fill()
        end
   end

   return widget
   end

   return separators
