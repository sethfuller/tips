# put this in your .bash_profile
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi

# Piece-by-Piece Explanation:
# The if condition makes sure we only screw with $PROMPT_COMMAND if we're in an iTerm environment
#
# iTerm happens to give each session a unique $ITERM_SESSION_ID we can use, $ITERM_PROFILE is an option too
# the $PROMPT_COMMAND environment variable is executed every time a command is run
#
# see: ss64.com/bash/syntax-prompt.html
#
# We want to update the iTerm tab title to reflect the current directory (not full path, which is too long)
#
# echo -ne "\033;foo\007" sets the current tab title to "foo"
#
# See: stackoverflow.com/questions/8823103/how-does-this-script-for-naming-iterm-tabs-work
#
# the two flags, -n = no trailing newline & -e = interpret backslashed characters, e.g. \033 is ESC, \007 is BEL
#
# See: ss64.com/bash/echo.html for echo documentation
#
# We set the title to ${PWD##*/} which is just the current dir, not full path
# see: stackoverflow.com/questions/1371261/get-current-directory-name-without-full-path-in-bash-script
# Then we append the rest of $PROMPT_COMMAND so as not to remove what was already there
# voilà!

# put this in your .bash_profile
if [ $ITERM_SESSION_ID ]; then
  export PROMPT_COMMAND='echo -ne "\033];${PWD##*/}\007"; ':"$PROMPT_COMMAND";
fi
