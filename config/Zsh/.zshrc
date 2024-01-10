export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias java-11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version; echo $JAVA_HOME"
alias java-21="export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version; echo $JAVA_HOME"

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
alias myip='echo "Current IP: $(ifconfig | fgrep 10.0)"' # Internal IP

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
alias mc="minicom -c on"

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

# source $HOME/Src/Shell/Zsh/sh-autocomplete/zsh-autocomplete.plugin.zsh

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
[[ $- = *i* ]] && source $HOME/.zshrc-liquidprompt

#launchctl setenv PATH $PATH

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /usr/local/Cellar/gnu-getopt/2.39.2/etc/bash_completion.d/getopt
# source $HOME/.gsf-completion.bash

myip.sh

autoload -Uz compinit
compinit

unalias gsd
alias gsd='_gsd'

alias git=/opt/homebrew/opt/git/bin/git
alias python3=/opt/homebrew/opt/python3/bin/python3
alias pip3=/opt/homebrew/opt/python3/bin/pip3
alias ruby3=/opt/homebrew/opt/ruby/bin/ruby

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# zinit snippet 'https://github.com/robbyrussell/oh-my-zsh/raw/master/plugins/git/git.plugin.zsh'
zinit snippet OMZ::plugins/git/git.plugin.zsh
# zinit snippet PZT::modules/helper/init.zsh
### End of Zinit's installer chunk

source ~/Src/Shell/zsh-completions/src/kubectl-autocomplete.plugin.zsh
source ~/Src/Shell/zsh-completions/src/mvn.plugin.zsh

echo "End .zshrc $(date)"
