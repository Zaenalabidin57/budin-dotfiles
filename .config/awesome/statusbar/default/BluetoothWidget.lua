--[[
     Bluetooth Widget for Awesome WM
--]]

-- Standard awesome library
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

-- Wibox handling library
local wibox = require("wibox")

-- Create a container for devices
local devices_container = wibox.layout.fixed.vertical()

-- Bluetooth icon
local bluetooth_icon = wibox.widget.imagebox(beautiful.widget_bluetooth or beautiful.widget_net)

-- Main text display
local bluetooth_text = wibox.widget {
    widget = wibox.widget.textbox,
    markup = "BT",
    font = beautiful.font or "Sans 10",
    align = "left",
    valign = "center",
}

-- Main widget layout
local bluetooth_widget = wibox.widget {
    bluetooth_icon,
    bluetooth_text,
    layout = wibox.layout.fixed.horizontal
}

-- The widget that will hold the device list
local devices_widget = wibox.widget {
    devices_container,
    visible = false,
    layout = wibox.layout.fixed.vertical
}

-- Function to update bluetooth status
local function update_bluetooth()
    awful.spawn.easy_async_with_shell(
        "bluetoothctl show | grep 'Powered: yes' && echo on || echo off",
        function(stdout)
            local status = stdout:gsub("\n", "")
            if status == "on" then
                bluetooth_text:set_markup(" <span foreground='#88cc88'>ON</span>")
                bluetooth_icon:set_image(beautiful.widget_bluetooth or beautiful.widget_net)
                
                -- Update connected devices
                awful.spawn.easy_async_with_shell(
                    "bluetoothctl devices Connected | cut -d' ' -f3-",
                    function(device_stdout)
                        -- Clear the container
                        devices_container:reset()
                        
                        local device_list = {}
                        for device in device_stdout:gmatch("[^\n]+") do
                            table.insert(device_list, device)
                        end
                        
                        if #device_list > 0 then
                            for _, device in ipairs(device_list) do
                                local device_text = wibox.widget {
                                    widget = wibox.widget.textbox,
                                    markup = "  • " .. device,
                                    font = beautiful.font or "Sans 9",
                                }
                                devices_container:add(device_text)
                            end
                            devices_widget.visible = true
                        else
                            devices_widget.visible = false
                        end
                    end
                )
            else
                bluetooth_text:set_markup(" <span foreground='#cc8888'>OFF</span>")
                bluetooth_icon:set_image(beautiful.widget_bluetooth_off or beautiful.widget_net)
                devices_widget.visible = false
            end
        end
    )
end

-- Timer to update every 30 seconds
gears.timer {
    timeout = 30,
    autostart = true,
    call_now = true,
    callback = update_bluetooth
}

-- Toggle Bluetooth on click
bluetooth_widget:buttons(gears.table.join(
    awful.button({}, 1, function()
        awful.spawn.with_shell("bluetoothctl power toggle")
        gears.timer.start_new(1, function()
            update_bluetooth()
            return false
        end)
    end),
    awful.button({}, 3, function()
        awful.spawn(terminal .. " -e bluetoothctl")
    end)
))

-- Create the combined widget with dropdown
local combined_widget = wibox.widget {
    bluetooth_widget,
    devices_widget,
    layout = wibox.layout.fixed.vertical
}

return combined_widget
