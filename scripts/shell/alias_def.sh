
ARGS=$*

# -i - interactive
# -x - xtrace (echo commands)
# -c - Used on the command line to specify a single command
# : - Equivalent of true
zsh -ixc : 2>&1 |grep "$ARGS"
