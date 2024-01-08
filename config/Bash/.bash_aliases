#!/bin/bash
# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
alias df='df -h'
alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
alias ls='ls -hF'
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias ltr='ls -ltr'                           # long list reverse sort by time
alias lh='ls -lh'                             # long list (sizes human readable)
alias la='ls -lA'                             # all but . and ..
alias lal='la | less'                         # la pipe through less
alias l='ls -CF'                              # 

alias c=clear
alias mkdir='mkdir -pv'                       # Create missing dirs. and show them

# Functions in ~/.bash_functions
alias nf=numfiles                             # numfiles Count files in a dir
alias nfr=numfiles_recurse                    # numfiles_recurse Count files recursively

# Python pip
alias pipi='pip install'
alias pips='pip search'

# Docker
alias dock='docker'
alias dc='docker-compose'
alias dcont='docker container'

echo "Finish $HOME/.bash_aliases At: $(date)"
