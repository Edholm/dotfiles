#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

umask u=rwx,g=rx,o=
eval $(dircolors ~/.dircolors)

# Larger bash history (allow 32³ entries; default is 500)
export HISTSIZE=32768
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth
# Make some commands not show up in history
export HISTIGNORE="cd ..:ls:sl:ls -la:cd:cd -:pwd:exit:date:logout"

if [[ -n "$DISPLAY" ]]; then
    export BROWSER=google-chrome
else
    export BROWSER=w3m
fi

# Highlight section titles in manual pages
export LESS_TERMCAP_md="$ORANGE"

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Map Ctrl-S to sth usefull other than XOFF (interrupt data flow).
stty -ixon

export HISTCONTROL=ignoreboth
export GOPATH="/home/eda/git-repos/golang"
export PATH=$PATH":/home/eda/.bin:/home/eda/git-repos/golang/bin"
export FILESERVER=/home/eda/fs-mnt
export UPPACKAT=$FILESERVER"/Uppackat"
export SERIER=$FILESERVER"/\#Storage/TV-Shows/"
export EDITOR=vim
export GTK2_RC_FILES=/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0
source $HOME/.bin/git-prompt.sh

alias gs='git status'
alias gd='git diff'
alias sl='ls'
alias p='sudo pacman -S'
alias pa='packer -S'
alias pRus='sudo pacman -Rus'
alias pacman='sudo pacman'
alias vims='sudoedit'
alias df='df -h'
alias du='du -hc'
alias ls='ls -hF --color=always --group-directories-first'
alias grep='grep --color=auto'
alias passwordmaker='passwordmaker -a RIPEMD160 -x -g 14 -r '
alias ping='ping -c 3'
alias halt='systemctl poweroff'
alias reboot='systemctl reboot'
alias shutdown='systemctl poweroff'
alias poweroff='systemctl poweroff'
alias xprop='xprop -notype WM_CLASS WM_NAME WM_WINDOW_ROLE'
alias subliminal='subliminal -l en'
alias pss='ps -A -o pid,user,cmd | grep'

function sudo () { [[ $1 == vim ]] && shift && sudoedit "$@" || command sudo "$@"; }

function duf {
du -k "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}

autoFSMount() {
	if [ ! -d "$1" ]; then
		sh /home/eda/.bin/fsmnt
	fi
}
cduppackat() {
	autoFSMount $UPPACKAT
	cd $UPPACKAT
}
cdserier() {
	autoFSMount $SERIER 
	cd $SERIER
}
cdfsmnt() {
	sh /home/eda/.bin/fsmnt
	cd $FILESERVER
}

export GREP_COLOR="1;33"
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
PS1='\[\e[0;32m\]\u\[\e[0;37m\]@\[\e[0;36m\]\h \[\e[0;37m\][\W]$(__git_ps1 " \[\e[0;31m\](%s)") \[\e[0;32m\]\$ \[\e[0;37m\]'
