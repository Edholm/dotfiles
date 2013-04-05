-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local scratch = require("scratch")
local vicious = require("vicious")
require("gmail_custom")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/eda/.config/awesome/themes/solarized-dark/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Define some folders
base_dir    = "/home/eda/"
awesome_dir = base_dir .. ".config/awesome/"
icons       = awesome_dir .. "icons/"

-- Define some colors
yellow = "#b58900"
base00 = "#657b83"
base01 = "#586e75"
base02 = "#073642"
base03 = "#002b36"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.max,
    --awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names   = { "1-web", "2-foo", "3-bar", 4, 5, 6, "7-spotify", "8-skype", 9 },
    layouts = {layouts[1],layouts[1],layouts[1],layouts[1],layouts[1],layouts[1],
                layouts[1],layouts[2],layouts[1]},
    icons   = {icons .. "tv.xbm", icons .. "code.xbm", nil, nil, nil, icons .. "spotify.xbm", icons .. "mail.xbm", nil}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layouts)
    --if tagseparator then
    --    for i, t in ipairs(tags[s]) do
    --        awful.tag.seticon(tags.icons[i], t)
    --    end
    --end
    awful.tag.setmwfact(0.25, tags[s][8])
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
local function notify(txt, tit, ico)
    naughty.notify({
            text = txt,
            title = tit,
            position = "top_right",
            timeout = 7,
            icon = icons .. ico,
            fg="#fff",
            bg="#002b36",
            screen = 1,
            ontop = true, 
        })
end
-- Create a textclock widget
--
-- Separator
separator = wibox.widget.imagebox()
separator:set_image(icons .. "separator.png")

-- Wlan widget
wlan_icon = wibox.widget.imagebox()
vicious.register(wlan_icon, vicious.widgets.wifi,
    function(widget, args) 
        link = args["{link}"]
        ssid = args["{ssid}"]
        if link > 75 or ssid == "N/A" then
            wlan_icon:set_image(icons .. "wlan_100.png")
        elseif link < 75 and link > 50 then
            wlan_icon:set_image(icons .. "wlan_75.png")
        elseif link < 50 and link > 25 then
            wlan_icon:set_image(icons .. "wlan_50.png")
        else
            wlan_icon:set_image(icons .. "wlan_25.png")
        end
    end, 7, "wlan0")
wlan_widget = wibox.widget.textbox()
vicious.register(wlan_widget, vicious.widgets.wifi, 
    function(widget, args)
        link = args["{link}"]
        ssid = args["{ssid}"]
        if ssid ~= "N/A" then
            return " " ..ssid .. " (<span color=\"" .. yellow .. "\">" .. link .. "%</span>)"
        else
           return " Not connected"
        end
    end, 7,  "wlan0") 

-- Battery widget
batwidget_icon = wibox.widget.imagebox()
vicious.register(batwidget_icon, vicious.widgets.bat,
    function(widget, args) 
        charge  = args[2]
        state   = args[1]
        if charge > 75 or state == "N/A" then
            batwidget_icon:set_image(icons .. "batt_100.png")
        elseif charge < 75 and charge > 50 then
            batwidget_icon:set_image(icons .. "batt_75.png")
        elseif charge < 50 and charge > 25 then
            batwidget_icon:set_image(icons .. "batt_50.png")
        elseif charge < 25 then 
            batwidget_icon:set_image(icons .. "batt_25.png")
            if charge <= 10 and args[1] == "-" then
                notify("Battery charge at <span color=\"red\">" .. charge .. "%</span>",
                       "Battery warning", "batt_25_big.png")
            end
        end
    end, 31, "BAT0")

batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, 
    function(widget, args)
        charge  = args[2]
        bat = " <span color=\"" .. yellow .. "\">" .. charge .. "%</span>"
        if args[1] ~= "-" then
            bat = ' <span color="' .. base01 .. '">' .. args[1] .. '</span>' .. bat
        end
        if args[3] ~= "N/A" then
            bat = bat .. " (<span color=\"" .. yellow .. "\">".. args[3] .. " left</span>)"
        end
        return bat
    end, 31, "BAT0")

-- Mail notification widget
local function mail_notify(address, count, subject)
    notify('You have <span color="red">' .. count .. '</span> new mail(s)\nSubject: ' .. subject,
            "New mail (" .. address .. ")",
            "gmail_color.png")
end
-- @edholm.it
gmail1_icon = wibox.widget.imagebox()
vicious.register(gmail1_icon, vicious.widgets.gmail,
    function(widget, args)
        if args["{count}"] > 0 then
            gmail1_icon:set_image(icons .. "gmail_color.png")
        end
    end, 181)

gmail1_widget = wibox.widget.textbox()
vicious.register(gmail1_widget, vicious.widgets.gmail,
    function(widget, args)
        count = args["{count}"]
        if count > 0 then
            subject = args["{subject}"]
            mail_notify("emil@edholm.it", count, subject)
            return ' <span color="' .. base01 .. '">emil@edholm.it:</span> <span color="red">' .. count .. '</span>' 
        else
            return " "
        end
    end, 181)

-- @chalmers.it
gmail2_icon = wibox.widget.imagebox()
vicious.register(gmail2_icon, vicious.widgets.gmail_custom,
    function(widget, args)
        if args["{count}"] > 0 then
            gmail2_icon:set_image(icons .. "gmail_color.png")
        end
    end, 181, { netrcfile = "~/.netrc_chalmers_it"})

gmail2_widget = wibox.widget.textbox()
vicious.register(gmail2_widget, vicious.widgets.gmail_custom,
    function(widget, args)
        count = args["{count}"]
        if count > 0 then
            subject = args["{subject}"]
            mail_notify("eda@chalmers.it", count, subject)
            return ' <span color="' .. base01 .. '">eda@chalmers.it:</span> <span color="red">' .. count .. '</span>' 
        else
            return " "
        end
    end, 181, {netrcfile = "/home/eda/.netrc_chalmers_it"})

-- Time/date widgets
clock_icon  = wibox.widget.imagebox()
clock_icon:set_image(icons .. "clock.png")
mydateclock = awful.widget.textclock(' <span color="' .. base00 .. '">%a %d %b</span>', 300)
--mydateclock = awful.widget.textclock(" %a %d %b", 307)
mytimeclock = awful.widget.textclock('<span color="' .. base01 .. '"> %H:%M </span>', 60)

spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(spacer)
    left_layout:add(mylayoutbox[s])
    left_layout:add(spacer)
    left_layout:add(spacer)
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    --if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spacer)
    right_layout:add(gmail1_icon)
    right_layout:add(gmail1_widget)
    right_layout:add(spacer)
    right_layout:add(gmail2_icon)
    right_layout:add(gmail2_widget)
    right_layout:add(spacer)
    right_layout:add(wlan_icon)
    right_layout:add(wlan_widget)
    right_layout:add(separator)
    right_layout:add(batwidget_icon)
    right_layout:add(batwidget)
    right_layout:add(separator)
    right_layout:add(clock_icon)
    right_layout:add(mydateclock)
    right_layout:add(mytimeclock)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "q", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey }, "r", 
        function ()  
            local yeganesh = "exe=\"yeganesh -x -- -nb \\#002b36 -nf \\#b58900 -sb \\#002b36 -sf \\#dc322f -fn -xos4-terminus-medium-r-normal-*-20-*-*-*-*-*-*-*\" && eval \"exec $exe\"" 
            awful.util.spawn(yeganesh)
        end),

    --awful.key({ modkey }, "x",
    --          function ()
    --              awful.prompt.run({ prompt = "Run Lua code: " },
    --              mypromptbox[mouse.screen].widget,
    --              awful.util.eval, nil,
    --              awful.util.getdir("cache") .. "/history_eval")
    --          end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),
    
    -- Scratch-pads
    awful.key({ modkey,         }, "s", function() scratch.drop(terminal .. " -title scratch", "bottom", "center", 1, 0.4) end),
    awful.key({ modkey, "Shift" }, "s", function() scratch.drop(terminal .. " -title center", "bottom", "center", 0.65, 0.65) end),
    awful.key({ modkey,         }, "x", function() scratch.drop(terminal .. " -title alsa -e alsamixer", "center", "center", 0.65, 0.65) end),
    awful.key({ modkey,         }, "z", function() scratch.drop(terminal .. " -title htop -e htop", "center", "center", 0.65, 0.65) end),
    awful.key({ modkey, "Shift" }, "i", function() scratch.drop(terminal .. " -title irc -e weechat-screen.sh", "center", "center", 0.85, 0.85) end),
    awful.key({ modkey, "Shift" }, "r", function() scratch.drop(terminal .. " -title fm -e ranger", "center", "center", 0.85, 0.85) end),
    
    -- Spawn apps
    awful.key({ modkey            }, "c", function() awful.util.spawn("firefox") end),
    awful.key({ modkey            }, "v", function() awful.util.spawn("firefox --private") end),
    awful.key({ modkey, "Control" }, "r", function() awful.util.spawn(terminal .. " -e ranger") end),

    -- Multimedia keys
    awful.key({},"XF86AudioMute",        function() awful.util.spawn("sh /home/eda/.scripts/cvol -t") end),
    awful.key({},"XF86AudioLowerVolume", function() awful.util.spawn("sh /home/eda/.scripts/cvol -d 5") end),
    awful.key({},"XF86AudioRaiseVolume", function() awful.util.spawn("sh /home/eda/.scripts/cvol -i 5") end),
    awful.key({},"XF86AudioNext",        function() awful.util.spawn("sh /home/eda/.scripts/mediacontroler.py next") end),
    awful.key({},"XF86AudioPrev",        function() awful.util.spawn("sh /home/eda/.scripts/mediacontroler.py next") end),
    awful.key({},"XF86KbdBrightnessDown",function() awful.util.spawn("asus-kbd-backlight down") end),
    awful.key({},"XF86KbdBrightnessUp",  function() awful.util.spawn("asus-kbd-backlight up") end),
    awful.key({},"XF86TouchpadToggle",   function() awful.util.spawn("/home/eda/.scripts/trackpad-toggle.sh") end)
  --awful.key({},"XF86ScreenBrightnessUp",function()awful.util.spawn("sudo-n/home/eda/.scripts/brightness.shup"),
  --awful.key({},"XF86ScreenBrightnessDown",function()awful.util.spawn("sudo-n/home/eda/.scripts/brightness.shdown")
    
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Skype" },
      properties = { tag = tags[1][8] } },
    { rule = { class = "Spotify" },
      properties = { tag = tags[1][7] } },
    { rule = { name = "Options" },
      properties = { floating = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
