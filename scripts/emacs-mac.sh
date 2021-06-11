
PROFILE=$1
if [ -z "$PROFILE" ]
then
    PROFILE="legacy"
fi

set -x
/usr/local/opt/emacs-mac/Emacs.app/Contents/MacOS/Emacs --with-profile $PROFILE &
set +x
