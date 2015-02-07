if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Gnome-keyring related
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GPG_AGENT_INFO SSH_AUTH_SOCK

# Set background
sh /home/eda/.fehbg &

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
urxvtd -q -f -o &

#Disable touchpad while typing
syndaemon -t -k -i 0.6 -d &

#To be able to load certain fonts
xset +fp /usr/share/fonts/local
xset fp rehash

xrdb -merge ~/.Xdefaults
exec i3
