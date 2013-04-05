-- Widget and layout library
local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")
local vicious = require("vicious")

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

-- Utility functions
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
local function mail_notify(address, count, subject)
    notify('You have <span color="red">' .. count .. '</span> new mail(s)\nSubject: ' .. subject,
            "New mail (" .. address .. ")",
            "gmail_color.png")
end

local function mail_status(icon, address, count, subject)
    if count > 0 then
        icon:set_image(icons .. "gmail_color.png")
        mail_notify(address, count, subject)
        return ' <span color="' .. base01 .. '">' .. address .. ':</span> <span color="red">' .. count .. '</span>' 
    else
        return " "
    end
end

-- Separator
separator = wibox.widget.imagebox()
separator:set_image(icons .. "separator.png")

spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- Wlan widget
wlan_icon = wibox.widget.imagebox()
wlan_widget = wibox.widget.textbox()
vicious.register(wlan_widget, vicious.widgets.wifi, 
    function(widget, args)
        link = args["{link}"]
        ssid = args["{ssid}"]
        if link > 75 or ssid == "N/A" then
            wlan_icon:set_image(icons .. "wlan_100.png")
        elseif link <= 75 and link > 50 then
            wlan_icon:set_image(icons .. "wlan_75.png")
        elseif link <= 50 and link > 25 then
            wlan_icon:set_image(icons .. "wlan_50.png")
        else
            wlan_icon:set_image(icons .. "wlan_25.png")
        end
        if ssid ~= "N/A" then
            return " " ..ssid .. " (<span color=\"" .. yellow .. "\">" .. link .. "%</span>)"
        else
           return " Not connected"
        end
    end, 7,  "wlan0") 

-- Battery widget
batt_icon = wibox.widget.imagebox()
batt_widget = wibox.widget.textbox()
vicious.register(batt_widget, vicious.widgets.bat, 
    function(widget, args)
        charge  = args[2]
        state   = args[1]
        if charge > 75 or state == "N/A" then
            batt_icon:set_image(icons .. "batt_100.png")
        elseif charge <= 75 and charge > 50 then
            batt_icon:set_image(icons .. "batt_75.png")
        elseif charge <= 50 and charge > 25 then
            batt_icon:set_image(icons .. "batt_50.png")
        elseif charge <= 25 then 
            batt_icon:set_image(icons .. "batt_25.png")
            if charge <= 10 and args[1] == "-" then
                notify("Battery charge at <span color=\"red\">" .. charge .. "%</span>",
                       "Battery warning", "batt_25_big.png")
            end
        end
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
-- @edholm.it
gmail1_icon = wibox.widget.imagebox()
gmail1_widget = wibox.widget.textbox()
vicious.register(gmail1_widget, vicious.widgets.gmail,
    function(widget, args)
        return mail_status(gmail1_icon, "emil@edholm.it", args["{count}"], args["{subject}"]) 
    end, 173)

-- @chalmers.it
gmail2_icon = wibox.widget.imagebox()
gmail2_widget = wibox.widget.textbox()
vicious.register(gmail2_widget, vicious.widgets.gmail_custom,
    function(widget, args)
        return mail_status(gmail2_icon, "eda@chalmers.it", args["{count}"], args["{subject}"]) 
    end, 181, {netrcfile = "/home/eda/.netrc_chalmers_it"})

-- Volume widget (clickable)
local vol, vol_state
volume_icon = wibox.widget.imagebox()
volume_widget = wibox.widget.textbox()
vicious.register(volume_widget, vicious.widgets.volume,
    function(widget, args)
        vol       = args[1]
        vol_state = args[2]
        if vol_state ~= "♫" or vol == 0 then
            volume_icon:set_image(icons .. "volume_muted.png")
        elseif vol > 66 then
            volume_icon:set_image(icons .. "volume_100.png")
        elseif vol <= 66 and vol > 33 then
            volume_icon:set_image(icons .. "volume_66.png")
        elseif vol <= 33 then 
            volume_icon:set_image(icons .. "volume_33.png")
        end
       return "" 
    end, 7, "Master")

-- Button
volume_icon:buttons(awful.util.table.join(
    awful.button({ }, 1, 
        function() 
            naughty.notify { text = "Volume: " .. vol .. "% (" .. vol_state .. ")", timeout = 5, hover_timeout = 0.5 }
        end)))
volume_widget:buttons(volume_icon:buttons())

-- Tooltip
--volume_tooltip = awful.tooltip({ objects = {volume_icon},})
--volume_icon:add_signal("mouse::enter", function()
--    volume_tooltip:set_text("Volume: " .. vol .. "% (" .. vol_state .. ")")
--end)

-- // Volume widget

-- Time/date widgets
clock_icon  = wibox.widget.imagebox()
clock_icon:set_image(icons .. "clock.png")
mydateclock = awful.widget.textclock(' <span color="' .. base00 .. '">%a %d %b</span>', 300)
--mydateclock = awful.widget.textclock(" %a %d %b", 307)
mytimeclock = awful.widget.textclock('<span color="' .. base01 .. '"> %H:%M </span>', 60)

