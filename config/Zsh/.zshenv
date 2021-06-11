export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";

export RUBY_HOME="/opt/homebrew/opt/ruby/"

source ~/bin/setj.sh

typeset -U path
path=(${RUBY_HOME}/bin $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin /usr/local/bin /usr/local/sbin  $HOME/bin $JAVA_HOME/bin $GO_HOME/bin $path)

