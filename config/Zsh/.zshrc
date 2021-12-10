export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# print 1 column
alias pr1='print -C1'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Grep
alias grep='grep --color'                       # show differences in colour
alias egrep='egrep --color=auto'                # show differences in colour
alias fgrep='fgrep --color=auto'                # show differences in colour

# ls aliases
alias ll='ls -lGF'                              # -G (colorized output) -F (show type of listing)
alias la='ll -A'                                # -A show all files/dirs exept . and ..
alias ltr='ll -tr'                              # long list reverse sort by time
alias lh='ll -h'                                # long list (sizes human readable)

alias mkdir='mkdir -pv'                         # Create missing dirs. and show them

alias tac='tail -r'                             # Display in reverse line order
alias br=brew                                   # Brew

export MVN_CL_INS="clean install -DskipTests"
alias mci="mvn $MVN_CL_INS"
alias muci="mvn -U $MVN_CL_INS"

alias extip="curl http://ipecho.net/plain;echo" # Public IP
alias myip='echo "Current IP: $(ifconfig | grep 192.)"' # Internal IP

# Python pip
alias pip='pip3'
alias pipi='pip install'
alias pips='pip search'

# alias -g (global) - Alias can appear anywhere on command line
alias -g ...='../..'
alias -g ca="|& cat"
alias -g cl='| wc -l'
# |& is shorthand for '2>&1 |'
alias -g eg='|& egrep'
alias -g eh='|& head'
alias -g el='|& less'
alias -g etl='|& tail -20'
alias -g et='|& tail'
alias -g gvg='|& grep -v grep'
alias -g brc='git brc'

alias -g cod='checkout develop'

# Show all git aliases with comments

alias gal="$HOME/bin/git_aliases.py"
alias brg="git brr | grep"

# alias em="$HOME/bin/emacs-mac.sh"
alias em="$HOME/bin/emacs-mac.sh -n"
alias emp="$HOME/bin/emacs-mac.sh -n 1 2 3"

alias ssht='~/Comcast/bin/ssh_tunnel.sh'

# git Branch Prefixes
export X1="sfulle176_EMX1"
export DV="develop"

# Make fpath contain only unique entries
typeset -U fpath
typeset -U cdpath
cdpath=(.. ~/Src /usr/local /usr/local/opt /opt/homebrew)

if type brew &>/dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

  # autoload -Uz compinit
  # compinit
fi

source $HOME/.zshrc-functions

# Path to find function files
fpath=($HOME/Src/Shell/zsh-completions/src $fpath)

# source $HOME/.gsf-completion.bash

# Zplug Init
# export ZPLUG_HOME=/usr/local/opt/zplug
# source $ZPLUG_HOME/init.zsh
# zplug "plugins/git" from:oh-my-zsh

# source $HOME/.zshrc-emacs
# source $HOME/.zshrc-antigen
source $HOME/.zshrc-liquidprompt

#launchctl setenv PATH $PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

myip.sh

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
# https://zdharma.github.io/zinit/wiki/ (Docs)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk
# zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/git/git.plugin.zsh'
# zinit snippet 'https://github.com/sorin-ionescu/prezto/blob/master/modules/helper/init.zsh'
zinit snippet OMZ::plugins/git/git.plugin.zsh

# zinit light zsh-users/zsh-syntax-highlighting
zinit load zsh-users/zsh-syntax-highlighting

autoload -Uz compinit
compinit

unalias gsd
alias gsd='_gsd'

echo "End .zshrc $(date)"
