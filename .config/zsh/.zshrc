xset r rate 200 80
[[ ! $- == *i* ]] && return

# Enable colors and change prompt:
autoload -U colors && colors
autoload -Uz compinit
compinit
# export GTK_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export QT_IM_MODULE=ibus
# export XIM_PROGRAM=/usr/bin/ibus-daemon
#PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b ${vcs_info_msg_0_} >"
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M%{$reset_color%} %B%{$fg[cyan]%}%1~%{$fg[red]%}]%{$reset_color%} \$%b "

typeset -A __DOTS

__DOTS[ITALIC_ON]=$'\e[3m'
__DOTS[ITALIC_OFF]=$'\e[23m'

PLUGIN_DIR=~/.config/zsh/plugins
source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh
source $PLUGIN_DIR/zsh-yarn-autocompletions/yarn-autocompletions.plugin.zsh
# Customize by CKO
unsetopt nomatch
# History in cache directory:

# [ ! -f $HISTFILE ] && mkdir "${HISTFILE%/*}" ; touch $HISTFILE
# Basic auto/tab complete:

# zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
#
# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Enable keyboard navigation of completions in menu
# (not just tab/shift-tab but cursor keys as well):
zstyle ':completion:*' menu select

# Make completion:
# (stolen from Wincent)
# - Try exact (case-sensitive) match first.
# - Then fall back to case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# persistent reshahing i.e puts new executables in the $path
# if no command is set typing in a line will cd by default
zstyle ':completion:*' rehash true

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''

# Style the group names
zstyle ':completion:*' format %F{yellow}%B%U%{$__DOTS[ITALIC_ON]%}%d%{$__DOTS[ITALIC_OFF]%}%b%u%f

# Allow completion of ..<Tab> to ../ and beyond.
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'

zmodload zsh/complist
# compinit
_comp_options+=(globdots) # Include hidden files.

# ==============================================================================
# Options
# ==============================================================================

setopt CORRECT        # command auto-correction
setopt AUTOPARAMSLASH # tab completing directory appends a slash
setopt SHARE_HISTORY  # Share your history across all your terminal windows
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
HISTSIZE=100000
SAVEHIST=100000
# HISCONTROL=ignoreboth:erasedups
HISTFILE=~/.cache/zsh/history

export KEYTIMEOUT=1
# if [[ -z $VIM ]]; then
bindkey -v
# Use vim keys in tab complete menu:
bindkey '^[[Z' reverse-menu-complete # s-tab
bindkey -s '^[[13;5u' 'ide\n'
bindkey -s '^[[13;6u' 'ide2\n'
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Change cursor shape for different vi modes.

function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'
	elif [[ ${KEYMAP} == main ]] ||
		[[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} = '' ]] ||
		[[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'
	fi
}

function zle-line-init() {
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
	echo -ne "\e[5 q"
}

zle -N zle-keymap-select
zle -N zle-line-init
# fi

# if [[ ! -z $VIM ]]; then
#   echo "test"
#   bindkey -r '^[/'
#   bindkey -rpM viins '^['
#   bindkey -rpM vicmd '^['
# fi

echo -ne '\e[5 q'                # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q'; } # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd() {
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
	fi
}

up() {
	local d=""
	local limit="$1"

	# Default to limit of 1
	if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
		limit=1
	fi

	for ((i = 1; i <= limit; i++)); do
		d="../$d"
	done

	# perform cd. Show error if cd fails
	if ! cd "$d"; then
		echo "Couldn't go up $limit dirs."
	fi
}

# Edit line in vim with ctrl-e:
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -s '^[o' 'lfcd\n'
bindkey -s '^[g' 'lazygit\n'
bindkey -s '^[u' 'up\n'

# Load auto suggestions
#
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cko/.local/src/anaconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
	eval "$__conda_setup"
else
	if [ -f "/home/cko/.local/src/anaconda3/etc/profile.d/conda.sh" ]; then
		. "/home/cko/.local/src/anaconda3/etc/profile.d/conda.sh"
	else
		export PATH="/home/cko/.local/src/anaconda3/bin:$PATH"
	fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"
# [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] && source /home/cko/.nix-profile/etc/profile.d/nix.sh

DEFAULT_PROMPT="$PROMPT"
[ -f ~/.config/zsh/plugins/git-prompt.zsh/git-prompt.zsh ] && . ~/.config/zsh/plugins/git-prompt.zsh/git-prompt.zsh
[ -f ~/.config/fzf/fzf.zsh ] && source ~/.config/fzf/fzf.zsh

ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

PROMPT="$DEFAULT_PROMPT"
RPROMPT='$(gitprompt)'
if [ ! -f /tmp/sources ]; then
	{
		cat ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
		minikube completion zsh
		kubectl completion zsh
		node --completion-bash
		npm completion
		deno completions bash
	} | tee /tmp/sources | source /dev/stdin
else
	source /tmp/sources
fi

# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=blue"
# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# fpath+=${ZDOTDIR:-~}/.zsh_functions

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# vim:	noexpandtab shiftwidth=4 tabstop=4 :
