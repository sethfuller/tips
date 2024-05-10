#!/usr/bin/env bash

# Start Chrome with a a specified profile

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

USER_DATA_DIR_EXT="$1"

if [ -z "$USER_DATA_DIR_EXT" ]
then
    USER_DATA_DIR_EXT="1"
fi
USER_DATA_DIR="$HOME/Google/Profile-${USER_DATA_DIR_EXT}"

set -x
"$CHROME" --user-data-dir=$USER_DATA_DIR & # > /dev/null 2>&1
set +x
