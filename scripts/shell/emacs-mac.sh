
PROFILE=$1
if [ -z "$PROFILE" ]
then
    PROFILE="default"
fi

VERSION=""
VERS_US=""
if [ $# -gt 1 ]
then
    VERSION="$2"
    VERS_US="_$VERSION"
fi

echo "\$#=$#"

set -x
# /usr/local/opt/emacs-plus${VERS_US}/Emacs${VERSION}.app/Contents/MacOS/Emacs --with-profile $PROFILE $ICON &

/Applications/Emacs${VERSION}.app/Contents/MacOS/Emacs --with-profile $PROFILE &

set +x
