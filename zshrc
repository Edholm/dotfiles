# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="gallifrey"
ZSH_THEME="eda"

# ALIAS
# List direcory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'
alias sl=ls # often screw this up
alias ls='ls -hF --color=always --group-directories-first'

# Git 
alias gs='git status'
alias gd='git diff'

# Pacman
alias p='sudo pacman -S'
alias pa='packer -S'
alias pRus='sudo pacman -Rus'
alias pacman='sudo pacman'

# Super-user
alias vims='sudoedit'

# Storage left
alias df='df -h'
alias du='du -hc'

# Shutdown/Reboot
alias halt='systemctl poweroff'
alias reboot='systemctl reboot'
alias shutdown='systemctl poweroff'
alias poweroff='systemctl poweroff'

# Process search
alias pss='ps -A -o pid,user,cmd | grep'

# Autocomplete .. to ../
zstyle ':completion:*' special-dirs true

#
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git command-not-found cp colored-man archlinux rsync)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export EDITOR="vim -X"

if [[ -n "$DISPLAY" ]]; then
    export BROWSER=google-chrome
else
    export BROWSER=w3m
fi
