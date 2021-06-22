
# PROFILE=$1
# if [ -z "$PROFILE" ]
# then
#     PROFILE="default"
#     shift
# fi

PROFILE="default"

echo "\$#=$#"

set -x
# /usr/local/opt/emacs-plus${VERS_US}/Emacs${VERSION}.app/Contents/MacOS/Emacs --with-profile $PROFILE $ICON &

for VERSION in $*
do
    /Applications/Emacs${VERSION}.app/Contents/MacOS/Emacs --with-profile $PROFILE &
done

set +x
