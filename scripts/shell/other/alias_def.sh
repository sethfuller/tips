
ARGS=$*

# Found in https://stackoverflow.com/questions/2614403/how-to-find-out-where-alias-in-the-bash-sense-is-defined-when-running-terminal/43245187#26742455
# -i - interactive
# -x - xtrace (echo commands)
# -c - Used on the command line to specify a single command
# : - Equivalent of true
zsh -ixc : 2>&1 |grep "$ARGS"
