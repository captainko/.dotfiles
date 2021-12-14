#!/usr/bin/env sh

# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
	PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.scripts" ]; then
	PATH="$HOME/.scripts:$PATH"
fi
if [ -d "$XDG_DATA_HOME/npm/bin" ]; then
	PATH="$XDG_DATA_HOME/npm/bin:$PATH"
fi
#export PATH=$PATH
sxhkd &
#setxkbmap -option "caps:swapescape" &
#setxkbmap -option caps:escape
#setxkbmap -option escape:caps

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

if [ -s "$HOME/.rvm/scripts/rvm" ]; then
	. "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
fi

setxkbmap -option caps:escape
xset r rate 200 80
. "$XDG_DATA_HOME/cargo/env"
# . "$XDG_CONFIG_HOME/env"
