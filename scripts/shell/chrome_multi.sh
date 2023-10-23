
PROFILE=$1
if [ -z "$PROFILE" ]
then
    PROFILE="PEEL"
fi

set -x
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir=~/Documents/Chrome-$PROFILE

set +x
