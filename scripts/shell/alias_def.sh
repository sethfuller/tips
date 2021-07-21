
ARGS=$*

zsh -ixc : 2>&1 |grep "$ARGS"
