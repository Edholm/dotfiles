local io = { popen = io.popen, input = io.input }
local setmetatable = setmetatable
local string = { gmatch = string.gmatch, sub = string.sub, find = string.find }
local tonumber = tonumber
local helpers = require("vicious.helpers")

-- Spotify: Current playing song from spotify (Linux Preview)
module("vicious.widgets.spotify")


local function worker(format, warg)
    local spotify  = {
        ["{State}"]  = "N/A",
        ["{Artist}"] = "Not",
        ["{Title}"]  = "playing",
        ["{Album}"]  = "N/A",
        ["{Year}"]   = "N/A",
        ["{Url}"]    = "N/A",
        ["{Rating}"] = 0, -- In percentage
    }

    local tmp_file = '/tmp/vicious-spotify'
    io.popen('/bin/bash -c "exec /usr/bin/qdbus-qt4 org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player PlaybackStatus " > ' .. tmp_file):close()
    local tmp = io.input(tmp_file)
    local state = tmp:read("*l")
    tmp:close()
    if state == 'Playing' then
	spotify["{State}"] = 'Playing'
	local metadata = io.popen('/bin/bash -c "exec /usr/bin/qdbus-qt4 org.mpris.MediaPlayer2.spotify / org.freedesktop.MediaPlayer2.GetMetadata"')
	for line in metadata:lines() do
	  for k, v in string.gmatch(line,"xesam:(%w+): (.*)") do
	    if	   k == "album"  then spotify["{Album}"]  = helpers.escape(v)
	    elseif k == "artist" then spotify["{Artist}"] = helpers.escape(v)
	    elseif k == "title"  then spotify["{Title}"]  = helpers.escape(v)
	    elseif k == "contentCreated"  then spotify["{Year}"]  = string.sub(v, 1, 4)
	    elseif k == "url"  then spotify["{Url}"]  = helpers.escape(v)
	    elseif k == "autoRating"  then spotify["{Rating}"]  = v and tonumber(v) * 100
	    end
	  end
       end
       metadata:close()
    elseif state == nil then
       spotify["{State}"] = 'Closed'
    else
       spotify["{State}"] = 'Paused'
    end
    return spotify
end

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
