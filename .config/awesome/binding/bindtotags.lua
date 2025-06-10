-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Key bindings

function _M.get(globalkeys)
    -- Bind bottom row keys (zxcvb) to tags.
    -- Modified to use specific bottom row keys instead of numbers.
    -- This maps to the bottom row of your keyboard: z, x, c, v, b.
    local keycodes = {52, 53, 54, 55, 56} -- Keycodes for z, x, c, v, b
    for i = 1, 5 do -- Only using 5 tags
        globalkeys = gears.table.join(globalkeys,

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- View tag only.
            awful.key({ modkey }, "#" .. keycodes[i],
                function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        tag:view_only()
                    end
                end,
                { description = "view tag #" .. i, group = "tag" }),

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. keycodes[i],
                function()
                    local screen = awful.screen.focused()
                    local tag = screen.tags[i]
                    if tag then
                        awful.tag.viewtoggle(tag)
                    end
                end,
                { description = "toggle tag #" .. i, group = "tag" }),

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. keycodes[i],
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:move_to_tag(tag)
                        end
                    end
                end,
                { description = "move focused client to tag #" .. i, group = "tag" }),

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. keycodes[i],
                function()
                    if client.focus then
                        local tag = client.focus.screen.tags[i]
                        if tag then
                            client.focus:toggle_tag(tag)
                        end
                    end
                end,
                { description = "toggle focused client on tag #" .. i, group = "tag" })

        --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
        )
    end

    return globalkeys
end

-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
