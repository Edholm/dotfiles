if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi

autoload -U colors && colors
PROMPT='%{$fg[$NCOLOR]%}%n%{$fg[white]%}@%{$fg[cyan]%}%m%{$reset_color%} %{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)%{$fg[green]%}%(!.#.$)%{$reset_color%} '
#RPROMPT='[%*]'


# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗"

eval $(dircolors ~/.dircolors)
export ZLS_COLORS=$LS_COLORS