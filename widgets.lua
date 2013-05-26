-- Widget and layout library
local awful   = require("awful")
local wibox   = require("wibox")
local naughty = require("naughty")
local vicious = require("vicious")
require("spotify")
require("wifi_mod")
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
green  = "#859900"

-- {{{ Utility functions
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
--local function mail_notify(address, count, subject)
--    notify('You have <span color="red">' .. count .. '</span> new mail(s)\nSubject: ' .. subject,
--            "New mail (" .. address .. ")",
--            "gmail_color.png")
--end
--
--local function mail_status(sep, icon, address, count, subject)
--    if count > 0 then
--        sep:set_image(icons .. "separator.png")
--        icon:set_image(icons .. "gmail_color.png")
--        mail_notify(address, count, subject)
--        return ' ' .. address .. ': <span color="red">' .. count .. '</span>' 
--    else
--        sep:set_image()
--        icon:set_image()
--        return " "
--    end
--end
-- }}} Utility functions

-- Separator
separator = wibox.widget.imagebox()
separator:set_image(icons .. "separator.png")

m1_sep = wibox.widget.imagebox()
m2_sep = wibox.widget.imagebox()

spacer = wibox.widget.textbox()
spacer:set_text(" ")

-- {{{ Spotify/Media widget
--spot_icon   = wibox.widget.imagebox()
--spot_widget = wibox.widget.textbox()
--spot_sep    = wibox.widget.imagebox()
--pb_back = wibox.widget.imagebox()
--pb_playpause = wibox.widget.imagebox()
--pb_forward = wibox.widget.imagebox()
--
--local spot_icon_s = icons .. "spotify.png"
--local spot_thumb  = "/tmp/spotify_thumb.png"
--local spot_track  = "N/A"
--local spot_album  = "N/A"
--local spot_artist = "N/A"
--local spot_year   = "N/A"
--local spot_url    = "N/A"
--local spot_rating = 0
--local spot_prev_album = ""
--vicious.register(spot_widget, vicious.widgets.spotify, 
--    function(widget, args)
--        spot_track  = args["{Title}"]
--        spot_artist = args["{Artist}"]
--        spot_album  = args["{Album}"]
--        spot_year   = args["{Year}"]
--        spot_url    = args["{Url}"]
--        spot_arturl = args["{ArtUrl}"]
--        spot_rating = args["{Rating}"]
--        if args["{State}"] ~= "Closed" then
--            pb_back:set_image(icons .. "back.png")
--            pb_forward:set_image(icons .. "forward.png")
--            spot_icon:set_image(spot_icon_s)
--            spot_sep:set_image(icons .. "separator.png")
--            if args["{State}"] == 'Playing' then
--                pb_playpause:set_image(icons .. "pause.png")
--                spot_thumb = "/tmp/spotify_thumb.png"
--
--                -- Download thumb if needed (Albums probably have the same thumb)
--                if spot_album ~= spot_prev_album then
--                    awful.util.spawn("wget -O /tmp/spotify_thumb.png -nv " .. spot_arturl )
--                    spot_prev_album = spot_album
--                end
--            else
--                spot_thumb = spot_icon_s
--                pb_playpause:set_image(icons .. "play.png")
--            end
--            return '<span color="' .. green .. '">' .. spot_artist .. ' - ' .. spot_track .. '</span>'
--        else
--            spot_thumb = spot_icon_s
--            spot_sep:set_image()
--            spot_icon:set_image()
--            pb_playpause:set_image()
--            pb_back:set_image()
--            pb_forward:set_image()
--            return ""
--        end
--    end, 97)
--
--n_spot = nil
--function destroy_spotify()
--    if n_spot ~= nil then
--        naughty.destroy(n_spot)
--        n_spot = nil
--    end
--end
--
--function update_spotify()
--    vicious.force({spot_widget,})
--end
--
--function show_spotify()
--  destroy_spotify()
--  n_spot = naughty.notify { 
--                title = "Spotify",
--                text = "Artist : " .. spot_artist
--                .. "\nTrack  : " .. spot_track 
--                .. "\nAlbum  : " .. spot_album
--                .. "\nYear   : " .. spot_year
--                .. "\nRating : " .. spot_rating
--                .. "%\nUrl    : " .. spot_url, 
--                timeout = 0,
--                icon = spot_thumb,
--                width=550
--            }
--end
--
--function copy_spot_url()
--    local string = { gmatch = string.gmatch }
--    -- Convert from spotify uri to http link
--    local url = "http://open.spotify.com/"
--    for k, v in string.gmatch(spot_url,"spotify:(%w+):(.*)") do
--        url = url .. k .. "/" .. v
--    end
--    io.popen("echo ".. url .. " | xsel -ibp")
--    naughty.notify( { text = "Spotify url copied to clipboard" })
---- http://open.spotify.com/track/0nJW01T7XtvILxQgC5J7Wh
---- spotify:track:0nJW01T7XtvILxQgC5J7Wh
--end
--
--spot_icon:connect_signal("mouse::enter", show_spotify)
--spot_icon:connect_signal("mouse::leave", destroy_spotify)
--spot_widget:connect_signal("mouse::enter", show_spotify)
--spot_widget:connect_signal("mouse::leave", destroy_spotify)
--
---- Playback buttons
----
--
--local qdbus = "qdbus-qt4 org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 "
--
--pb_back:buttons(awful.util.table.join(
--    awful.button({ }, 1, 
--    function() awful.util.spawn(qdbus .. "Previous") end)
--))
--
--pb_playpause:buttons(awful.util.table.join(
--    awful.button({ }, 1,
--    function() awful.util.spawn(qdbus .. "PlayPause") end)
--))
--
--pb_forward:buttons(awful.util.table.join(
--    awful.button({ }, 1, 
--    function() awful.util.spawn(qdbus .. "Next") end)
--))
--
---- Click on the widget to copy the spotify url
--spot_icon:buttons(awful.util.table.join(
--    awful.button({ }, 1, function() 
--        awful.tag.viewonly(awful.tag.gettags(mouse.screen)[6]) -- Change to wherever you send Spotify
--    end), 
--    awful.button({ }, 2, copy_spot_url ),
--    awful.button({ "Shift" }, 1, update_spotify ),
--    awful.button({ "Control", "Shift" }, 1, 
--        function() awful.util.spawn(qdbus .. "Quit") end)
--))
--spot_widget:buttons(spot_icon:buttons())
---- }}} Spotity/media widget
--
---- {{{ Wlan widget
wlan_icon = wibox.widget.imagebox()
wlan_widget = wibox.widget.textbox()
local w_ssid = "N/A"
local w_mode = "N/A"
local w_chan = 0
local w_rate = 0
local w_link = 0
local w_linp = 0
local w_sign = 0
local w_icon = nil
vicious.register(wlan_widget, vicious.widgets.wifi_mod, 
    function(widget, args)
        w_link = args["{link}"]
        w_ssid = args["{ssid}"]
        w_mode = args["{mode}"]
        w_chan = args["{chan}"]
        w_rate = args["{rate}"]
        w_linp = args["{linp}"]
        w_sign = args["{sign}"]
        if w_linp > 75 or w_ssid == "N/A" then
            w_icon = icons .. "wlan_100.png"
        elseif w_linp <= 75 and w_linp > 50 then
           w_icon = icons .. "wlan_75.png"
        elseif w_linp <= 50 and w_linp > 25 then
            w_icon = icons .. "wlan_50.png"
        else
            w_icon = icons .. "wlan_25.png"
        end
        wlan_icon:set_image(w_icon)
        if w_ssid ~= "N/A" then
            return " " ..w_ssid .. " (<span color=\"" .. yellow .. "\">" .. w_linp .. "%</span>)"
        else
           return " " .. w_ssid--" Not connected"
        end
    end, 37,  "wlan0") 
    
-- Hover effect 

-- }}}  Wlan widget
--wnot = nil
--function destroy_wlan()
--    if wnot ~= nil then
--        naughty.destroy(wnot)
--        wnot = nil
--    end
--end
--
--function update_wlan()
--    vicious.force({wlan_widget,})
--end
--
--function show_wlan()
--  destroy_wlan()
--  wnot = naughty.notify { 
--                title = "Wlan",
--                text = "SSID    : " .. w_ssid 
--                .. "\nLink    : " .. w_linp 
--                .. "%\nMode    : " .. w_mode 
--                .. "\nChannel : " .. w_chan
--                .. "\nRate    : " .. w_rate
--                .. "\nLink    : " .. w_link
--                .. "/70\nSignal  : " .. w_sign .. "db", 
--                timeout = 0,
--                icon = w_icon,
--                width=250
--            }
--end
--wlan_icon:connect_signal("mouse::enter", show_wlan)
--wlan_icon:connect_signal("mouse::leave", destroy_wlan)
--wlan_widget:connect_signal("mouse::enter", show_wlan)
--wlan_widget:connect_signal("mouse::leave", destroy_wlan)

-- {{{ Battery widget
local b_charge = 0 
local b_state  = ""
local b_time   = ""
local b_icon   = nil
local b_shown  = 0
batt_icon = wibox.widget.imagebox()
batt_widget = wibox.widget.textbox()
vicious.register(batt_widget, vicious.widgets.bat, 
    function(widget, args)
        b_charge  = args[2]
        b_state   = args[1]
        b_time    = args[3]
        if b_charge > 75 or b_state == "N/A" then
            b_icon = icons .. "batt_100.png"
        elseif b_charge <= 75 and b_charge > 50 then
            b_icon = icons .. "batt_75.png"
        elseif b_charge <= 50 and b_charge > 25 then
            b_icon = icons .. "batt_50.png"
        elseif b_charge <= 25 then 
            b_icon = icons .. "batt_25.png"
            if b_charge <= 10 and args[1] == "-" then
                -- Only show the notification every other update
                if b_shown % 2 == 0 then
                    notify("Battery charge at <span color=\"red\">" .. b_charge .. "%</span>",
                          "Battery warning", "batt_25_big.png")
                end
                b_shown = b_shown + 1 
            end
        end
        local retval = " " .. b_state;
        if b_state == "-" then -- discharging
            retval = retval .. " " .. b_charge .. "%"
            if args[3] ~= "N/A" then
                retval = retval .. " (<span color=\"" .. yellow .. "\">".. args[3] .. " left</span>)"
            end
        end
        batt_icon:set_image(b_icon)
        return retval
    end, 67, "BAT0")

-- Hover effect
battnot = nil
function destroy_battery()
    if battnot ~= nil then
        naughty.destroy(battnot)
        battnot = nil
    end
end

function update_battery()
    vicious.force({batt_widget,})
end

function show_battery()
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
  destroy_battery()
  battnot = naughty.notify { 
                title = "Battery",
                text = "Charge : " .. b_charge .. "%\nState  : " .. state ..
                " (" .. b_time .. ")", 
                timeout = 0,
                icon = b_icon
            }
end
batt_icon:connect_signal("mouse::enter", show_battery)
batt_icon:connect_signal("mouse::leave", destroy_battery)
batt_widget:connect_signal("mouse::enter", show_battery)
batt_widget:connect_signal("mouse::leave", destroy_battery)
-- }}} Battery widget

-- {{{ Mail notification widget
-- @edholm.it
--gmail1_icon = wibox.widget.imagebox()
--gmail1_widget = wibox.widget.textbox()
--vicious.register(gmail1_widget, vicious.widgets.gmail,
--    function(widget, args)
--        return mail_status(m1_sep, gmail1_icon, "emil@edholm.it", args["{count}"], args["{subject}"]) 
--    end, 113)
--
---- @chalmers.it
--gmail2_icon = wibox.widget.imagebox()
--gmail2_widget = wibox.widget.textbox()
--vicious.register(gmail2_widget, vicious.widgets.gmail_custom,
--    function(widget, args)
--        return mail_status(m2_sep, gmail2_icon, "eda@chalmers.it", args["{count}"], args["{subject}"]) 
--    end, 127, {netrcfile = "/home/eda/.netrc_chalmers_it"})
--
--gmail1_icon:buttons(awful.util.table.join(
--    awful.button({ }, 1, function() 
--        awful.util.spawn("google-chrome http://mail.google.com")
--    end) 
--))
--gmail1_widget:buttons(gmail1_icon:buttons())
--gmail2_icon:buttons(gmail1_icon:buttons())
--gmail2_widget:buttons(gmail1_icon:buttons())
--
---- }}} Mail widget
--
---- {{{ Volume widget
--vol = nil
--vol_state = nil
--vol_icon = nil
--volume_icon = wibox.widget.imagebox()
--volume_widget = wibox.widget.textbox()
--vicious.register(volume_widget, vicious.widgets.volume,
--    function(widget, args)
--        vol       = args[1]
--        vol_state = args[2]
--        if vol_state ~= "♫" or vol == 0 then
--            vol_icon = icons .. "volume_muted.png"
--        elseif vol > 66 then
--            vol_icon = icons .. "volume_100.png"
--        elseif vol <= 66 and vol > 33 then
--            vol_icon = icons .. "volume_66.png"
--        elseif vol <= 33 then 
--            vol_icon = icons .. "volume_33.png"
--        end
--        volume_icon:set_image(vol_icon)
--       return "" 
--    end, 7, "Master")
--
---- Hover info
--nvol = nil
--function destroy_volume()
--    if nvol ~= nil then
--        naughty.destroy(nvol)
--        nvol = nil
--    end
--end
--
--function update_volume()
--    vicious.force({volume_widget,})
--end
--
--function show_volume() 
--    destroy_volume()
--    nvol = naughty.notify({ 
--        text = "Volume" .. (vol_state ~= "♫" and " (muted)" or "")  .. ": " .. vol .. "%",
--        icon = vol_icon,
--        timeout = 0,
--        screen = mouse.screen,
--        ontop = true
--    })
--end
--volume_icon:connect_signal("mouse::enter", show_volume)
--volume_icon:connect_signal("mouse::leave", destroy_volume)
-- }}} Volume widget

-- {{{ Time/date widgets
date_widget = awful.widget.textclock(' <span color="' .. base00 .. '">%a %d %b</span>', 300)
time_widget = awful.widget.textclock('<span color="' .. base01 .. '"> %H:%M </span>', 60)

-- Button
--date_widget:buttons(awful.util.table.join(
--    awful.button({ }, 1, 
--        function() 
--            naughty.notify { text = awful.util.pread("cal"), timeout = 10, hover_timeout = 3 }
--        end)))
--time_widget:buttons(date_widget:buttons())

-- The following is taken from https://github.com/intrntbrn/awesome/blob/master/rc.lua (f55390b)
--function string:split(sep)
--    local sep, fields = sep or " ", {}
--    local pattern = string.format("([^%s]+)", sep)
--    self:gsub(pattern, function(c) fields[#fields+1] = c
--    end)
--    return fields
--end
--
--function readNetrc()
--    local netrc = io.open("/home/eda/.netrc", "r")
--    local gmailstr = netrc:read("*all")
--    netrc:close()
--    -- remove all unimportant strings
--    gmailstr = string.gsub(string.gsub(gmailstr, "machine mail.google.com login ", ""), "password ", "")
--    gmaildata = { }
--    -- token this string
--    gmaildata = gmailstr:split(" ")
--    guser = string.gsub(gmaildata[1], "\0", "")
--    gpw = string.gsub(gmaildata[2], "\n", "")
--    return nil
--end
--readNetrc()
--
--
--gcal = nil
--gcaldata = nil
--gcaltoday = nil
--
--function destroy_gcal()
--    if gcal~= nil then
--        naughty.destroy(gcal)
--        gcal = nil
--    end
--end
--
--
--function update_gcal()
--    if (guser and gpw) then
--        gcaldata = awful.util.pread("gcalcli --user " .. guser .. " --pw " .. gpw .. " --ignore-started --detail-location --locale sv_SE.UTF-8 --24hr --nc agenda")
--        gcaldata = string.gsub(gcaldata, "%$(%w+)", "%1")
--        gcaldata = gcaldata:match( "(.-)%s*$")
--        gcaltoday = os.date("%A, %d %B")
--    end
--    return nil
--end
--
--function show_gcal()
--    if (gcaldata) then
--        destroy_gcal()
--        gcal = naughty.notify({
--            title = "Google Calendar\n" .. gcaltoday,
--            text = "<span color='" .. base00 .. "'>" .. gcaldata .. "</span>",
--            timeout = 0,
--            fg = yellow,
--            screen = mouse.screen,
--            ontop = true,
--        })
--    end
--end
--
--gcaltimer = timer({ timeout = 3607 })
--gcaltimer:connect_signal("timeout", function() update_gcal() end)
--gcaltimer:start()
--
--update_gcal() -- still necessary for awesome.restart()
--
--date_widget:connect_signal("mouse::enter", show_gcal)
--date_widget:connect_signal("mouse::leave", destroy_gcal)
-- }}}  Time/date widgets
