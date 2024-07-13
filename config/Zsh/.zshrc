export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

alias java-11="export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version; echo $JAVA_HOME"
alias java-21="export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version; echo $JAVA_HOME"
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
path=($HOME/bin $HOME/bin/python /opt/homebrew/bin $path)

# Use locally installed angular
alias _ng='./node_modules/.bin/ng'

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

# Documentation: https://liquidprompt.readthedocs.io/en/stable/
# Add the following lines to your bash or zsh config (e.g. ~/.bash_profile):
if [ -f $(brew --prefix)/share/liquidprompt ]; then
  source $(brew --prefix)/share/liquidprompt
fi

# Setup a virtual environment
# python -m venv /path/to/new/virtual/environment
export PYTHONPATH=$(brew --prefix)/lib/python3.12/site-packages

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
zinit snippet OMZ::plugins/git/git.plugin.zsh

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

# echo "Before brew completions"
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi
# echo "After brew completions"

# Path to find function files
export ZSH_COMPLETIONS="${HOME}/Src/Shell/Zsh/zsh-completions/src"
fpath=($ZSH_COMPLETIONS $fpath)

echo "Before completions"
[ -f ${ZSH_COMPLETIONS}/_kubectl ] && source ${ZSH_COMPLETIONS}/_kubectl
[ -f ${ZSH_COMPLETIONS}/_angular ] && source ${ZSH_COMPLETIONS}/_angular

export DOCKER_HOME=/Applications/Docker.app
export DOCKER_ETC=${DOCKER_HOME}/Contents/Resources/etc

[ -f ${DOCKER_ETC}/docker-compose.zsh-completion ] && source ${DOCKER_ETC}/docker-compose.zsh-completion
[ -f ${DOCKER_ETC}/docker.zsh-completion ] && source ${DOCKER_ETC}/docker.zsh-completion

echo "After completions"


# echo "Before Angular completions"
# # Load Angular CLI autocompletion.
# # source <(ng completion script)
# echo "After Angular completions"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh --no-use"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
