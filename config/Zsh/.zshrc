export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# -G show colorized output
alias ll='ls -lG'
alias la='ll -A'

alias mkdir='mkdir -pv'

# Display in reverse line order
alias tac='tail -r'
alias br=brew

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

alias -g cod='checkout develop'

# Show all git aliases with comments

alias gal="$HOME/bin/git_aliases.py NO_PRINT"
alias brg="git brr | grep"

# alias em="$HOME/bin/emacs-mac.sh"
alias em="$HOME/bin/emacs-osx.sh"

# git Branch Prefixes
export X1="sfulle176_EMX1"
export DV="develop"

if type brew &>/dev/null; then
  fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

  # autoload -Uz compinit
  # compinit
fi

source $HOME/.zshrc-functions

# source $HOME/.gsf-completion.bash

# Zplug Init
# export ZPLUG_HOME=/usr/local/opt/zplug
# source $ZPLUG_HOME/init.zsh
# zplug "plugins/git" from:oh-my-zsh

source $HOME/.zshrc-emacs
# source $HOME/.zshrc-antigen
source $HOME/.zshrc-liquidprompt


# Path to find function files
fpath=($HOME/Src/Shell/zsh-completions/src $fpath)

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

echo "End .zshrc $(date)"
