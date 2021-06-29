export HOMEBREW_PREFIX="/opt/homebrew";
export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
export HOMEBREW_REPOSITORY="/opt/homebrew";

export RUBY_HOME="/opt/homebrew/opt/ruby/"

# For building Chromium
export DEPOT_TOOLS_HOME="$HOME/Src/SoftwareDev/Browsers/Chromium/depot_tools"

source ~/bin/setj.sh

# typeset -U path sets the array path so that only unique entries are kept
# The path array sets the PATH environment variable automatically
typeset -U path
path=(${RUBY_HOME}/bin $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin /usr/local/bin /usr/local/sbin  $HOME/bin $JAVA_HOME/bin $GO_HOME/bin $DEPOT_TOOLS_HOME $path)

