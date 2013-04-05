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

local function mail_status(sep, icon, address, count, subject)
    if count > 0 then
        sep:set_image(icons .. "separator.png")
        icon:set_image(icons .. "gmail_color.png")
        mail_notify(address, count, subject)
        return ' <span color="' .. base01 .. '">' .. address .. ':</span> <span color="red">' .. count .. '</span>' 
    else
        sep:set_image()
        icon:set_image()
        return " "
    end
end

-- Separator
separator = wibox.widget.imagebox()
separator:set_image(icons .. "separator.png")

m1_sep = wibox.widget.imagebox()
m2_sep = wibox.widget.imagebox()

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
-- Buttons
wlan_icon:buttons(awful.util.table.join(
    awful.button({ }, 1, 
        function() 
            -- needs nopasswd in visudo
            naughty.notify { text = "Available access points:\n" ..  awful.util.pread("sudo iwlist wlan0 scan | grep ESSID | awk -F\\\" \'{print $(NF-1)}\'"), timeout = 10, hover_timeout = 3 }
        end)))
wlan_widget:buttons(wlan_icon:buttons())
-- // Wlan widget

-- Battery widget
local b_charge  = 0 
local b_state   = ""
local b_time    = ""
batt_icon = wibox.widget.imagebox()
batt_widget = wibox.widget.textbox()
vicious.register(batt_widget, vicious.widgets.bat, 
    function(widget, args)
        b_charge  = args[2]
        b_state   = args[1]
        b_time    = args[3]
        if b_charge > 75 or b_state == "N/A" then
            batt_icon:set_image(icons .. "batt_100.png")
        elseif b_charge <= 75 and b_charge > 50 then
            batt_icon:set_image(icons .. "batt_75.png")
        elseif b_charge <= 50 and b_charge > 25 then
            batt_icon:set_image(icons .. "batt_50.png")
        elseif b_charge <= 25 then 
            batt_icon:set_image(icons .. "batt_25.png")
            if b_charge <= 10 and args[1] == "-" then
                notify("Battery b_charge at <span color=\"red\">" .. b_charge .. "%</span>",
                       "Battery warning", "batt_25_big.png")
            end
        end
        local retval = " " .. b_state;
        if b_state == "-" then -- discharging
            retval = retval .. " <span color=\"" .. yellow .. "\">" .. b_charge .. "%</span>"
            if args[3] ~= "N/A" then
                retval = retval .. " (<span color=\"" .. yellow .. "\">".. args[3] .. " left</span>)"
            end
        end
        return retval
    end, 31, "BAT0")

-- Button
function popup_bat()
  local state = ""
  if b_state == "↯" then
    state = "Full"
  elseif b_state == "↯" then
    state = "Charged"
  elseif b_state == "+" then
    state = "Charging"
  elseif b_state == "-" then
    state = "Discharging"
  elseif b_state == "⌁" then
    state = "Not charging"
  else
    state = "Unknown"
  end

  naughty.notify { text = "Charge : " .. b_charge .. "%\nState : " .. state ..
    " (" .. b_time .. ")", timeout = 5, hover_timeout = 0.5 }
end
batt_widget:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
batt_icon:buttons(batt_widget:buttons())
-- // Battery widget

-- Mail notification widget
-- @edholm.it
gmail1_icon = wibox.widget.imagebox()
gmail1_widget = wibox.widget.textbox()
vicious.register(gmail1_widget, vicious.widgets.gmail,
    function(widget, args)
        return mail_status(m1_sep, gmail1_icon, "emil@edholm.it", args["{count}"], args["{subject}"]) 
    end, 173)

-- @chalmers.it
gmail2_icon = wibox.widget.imagebox()
gmail2_widget = wibox.widget.textbox()
vicious.register(gmail2_widget, vicious.widgets.gmail_custom,
    function(widget, args)
        return mail_status(m2_sep, gmail2_icon, "eda@chalmers.it", args["{count}"], args["{subject}"]) 
    end, 181, {netrcfile = "/home/eda/.netrc_chalmers_it"})
-- // Mail widget

-- Volume widget
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
-- // Volume widget

-- Time/date widgets
clock_icon  = wibox.widget.imagebox()
clock_icon:set_image(icons .. "clock.png")
mydateclock = awful.widget.textclock(' <span color="' .. base00 .. '">%a %d %b</span>', 300)
mytimeclock = awful.widget.textclock('<span color="' .. base01 .. '"> %H:%M </span>', 60)

-- Button
clock_icon:buttons(awful.util.table.join(
    awful.button({ }, 1, 
        function() 
            naughty.notify { text = awful.util.pread("cal"), timeout = 10, hover_timeout = 3 }
        end)))
mydateclock:buttons(clock_icon:buttons())
mytimeclock:buttons(clock_icon:buttons())
-- // Time/date widgets
