###export DE="xfce"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Set background
sh /home/eda/.fehbg &

# Keyboard related settings
#unclutter -grab -noevents -root &
setxkbmap -layout se
xbindkeys
xsetroot -cursor_name left_ptr &
# Bind escape to capslock (easier vim usage)
xmodmap ~/.capslock

# Keyboard repeat delay
xset r rate 250 &

#compton &

# Suspend after 10 min and disable screen saver
xset dpms 720 1000 700
xset s 600 120 &
xss-lock -n /home/eda/.bin/dimmer.sh -- i3lock-wrapper -n &
#xss-lock -- i3lock -n -i /home/eda/rnd-junk/pics/fu_black.png &

# Start urxvt daemon
urxvtd -q -f -o &

# Auto mounting media
#devmon &

#Disable touchpad while typing
syndaemon -t -k -i 2 -d &
#dispad &

#To be able to load certain fonts
xset +fp /usr/share/fonts/local
xset fp rehash

# Multitouch gestures
#synclient TapButton2=2 TapButton3=0 ClickFinger2=0 ClickFinger3=0 HorizTwoFingerScroll=0 #VertTwoFingerScroll=0
#touchegg &
xrdb -merge ~/.Xdefaults
#exec xmonad
# Update gcal after we've gotten internet access.
#(sleep 60 && echo -e 'update_gcal()' | awesome-client) &
#exec awesome
#sxhkd &
#[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
#mkfifo "$PANEL_FIFO"
#exec bspwm -s "$PANEL_FIFO" -p W
exec i3 --shmlog-size=26214400
