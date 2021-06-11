
PROFILE=$1
if [ -z "$PROFILE" ]
then
    PROFILE="default"
fi

set -x
# /Applications/Emacs.app/Contents/MacOS/Emacs --with-profile $PROFILE &

/Applications/Emacs.app/Contents/MacOS/Emacs-x86_64-10_14 &
set +x
