# Langnostic's .profile
#
# Reminder: This file is not read by bash, if ~/.bash_profile or ~/.bash_login exists.
#
# Setup various shell variables used across environments
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE=-
export HISTFILE="$XDG_CACHE_HOME/bash_history"

# Remove Python History file with this pythonrc config
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"

# Aliases used across shells
# not include 'l' alias, because i want to use fish abbr for it
alias ls="ls --color=auto"
alias wget="wget --hsts-file $XDG_CACHE_HOME/wget_history"

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists (as a file or symlink)
    if [[ -f "$HOME/.bashrc" || -L "$HOME/.bashrc" ]]; then
	. "$HOME/.bashrc"
    fi
fi
