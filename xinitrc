if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

xrdb -merge ~/.Xresources

# Gnome-keyring related
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GPG_AGENT_INFO SSH_AUTH_SOCK

# Flush keyring and sudo password
 xss-lock -- /home/eda/.bin/on-suspend.sh &

# Set background
sh /home/eda/.bin/random-bg.sh &


# Make Capslock act as escape/control
setxkbmap se-coder -option 'lv3:caps_switch'
xcape -e 'ISO_Level3_Shift=Escape'

# Keyboard related settings
xbindkeys
xsetroot -cursor_name left_ptr &

# Bind escape to capslock (easier vim usage)
setxkbmap -option caps:escape

# Keyboard repeat delay
xset r rate 200 30

# Suspend after 10 min and disable screen saver
xset dpms 720 1000 1000
xset s 600 120 &
    #xss-lock -n /home/eda/.bin/dimmer.sh -- i3lock-wrapper -n &

# Start urxvt daemon
#urxvtd -q -f -o &

#Disable touchpad while typing
syndaemon -t -k -i 1.0 -d &

#To be able to load certain fonts
xset +fp /usr/share/fonts/local
xset fp rehash

exec i3
