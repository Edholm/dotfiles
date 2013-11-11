export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Set background
sh /home/eda/.fehbg &

# Keyboard related settings
setxkbmap -layout se
xbindkeys
xsetroot -cursor_name left_ptr &
# Bind escape to capslock (easier vim usage)
xmodmap ~/.capslock

# Keyboard repeat delay
xset r rate 250 &

# Suspend after 10 min and disable screen saver
xset dpms 720 1000 700
xset s 600 120 &
xss-lock -n /home/eda/.bin/dimmer.sh -- i3lock-wrapper -n &

# Start urxvt daemon
urxvtd -q -f -o &

#Disable touchpad while typing
syndaemon -t -k -i 2 -d &

#To be able to load certain fonts
xset +fp /usr/share/fonts/local
xset fp rehash

xrdb -merge ~/.Xdefaults
#exec xmonad
exec i3 --shmlog-size=26214400
