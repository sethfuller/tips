#!/usr/bin/env bash
##^ ## Author: Seth Fuller
##^ ## Date: 25-June-20201

usage() {
    message "Usage: $0 new_app_path [-i new_icon_path] [-o orig_app_path - Defaults to /Applications/Emacs.app]"
    echo "If new_app_path or orig_app_path do not begin with a '/' /Applications/ will be prepended to them"
    echo "If new_app_path or orig_app_path do not end with '.app' .app will be appended to them"
    message "A valid command line could be:"
    message "$0 Emacs2 -i /path/to/icon/file -o Emacs"
    echo "The new_icon_path is the .icns file that will replace Emacs.icns in /Applications/<new_app>/Countents/Resources"
    exit 1
}

message() {
    echo $*
    echo ""
}

NEW_APP=$1
shift

PARSED_ARGS=$(getopt i:o: $*)
VALID_ARGUMENTS=$?

if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

if [ -z "$NEW_APP" ]
then
    usage
fi

if [[ ! "$NEW_APP" =~ .app$ ]]
then
    NEW_APP="${NEW_APP}.app"
fi

if [[ ! "$NEW_APP" =~ ^/Applications ]]
then
    NEW_APP="/Applications/${NEW_APP}"
fi

set -- $PARSED_ARGS

for i
do
#    echo "i=$i 2=$2"
    case "$i"
    in
        -i)
            # echo icon is "'"$2"'"
            NEW_ICON="$2"; shift;
            shift;;
        -o)
            # echo orig app is "'"$2"'"
            ORIG_APP="$2"; shift;
            shift;;
        --)
            shift; break;;
    esac
done

if [ -z "$ORIG_APP" ]
then
    ORIG_APP="/Applications/Emacs.app/"
else
    if [[ ! "$ORIG_APP" =~ .app$ ]]
    then
        ORIG_APP="${ORIG_APP}.app"
    fi

    if [[ ! "$ORIG_APP" =~ ^/ ]]
    then
        ORIG_APP="/Applications/${ORIG_APP}"
    fi
fi

# echo "icon=$NEW_ICON orig=$ORIG_APP new_app=$NEW_APP"
message "icon=$NEW_ICON orig=$ORIG_APP new_app=$NEW_APP"
mkdir -pv "${NEW_APP}/Contents/Resources"

cd ${NEW_APP}/Contents

echo "Linking files/dirs in ${ORIG_APP}/Contents/ to ${NEW_APP}/Contents"
message "This will cause the linking command to say 'Resources: File exists', that is OK"

ln -s ${ORIG_APP}/Contents/* .

cd ${NEW_APP}/Contents/Resources

ln -s ${ORIG_APP}/Contents/Resources/* .

message "Removing ${NEW_APP}/Contents/Resources/Emacs.icns a link to ${ORIG_APP}/Contents/Resources/Emacs.icns"
rm ${NEW_APP}/Contents/Resources/Emacs.icns

if [ ! -z "$NEW_ICON" -a -f "$NEW_ICON" ]
then
    message "Copying $NEW_ICON to ${NEW_APP}/Contents/Resources/Emacs.icns"
    cp $NEW_ICON Emacs.icns
elif [ ! -z "$NEW_ICON" -a ! -f "$NEW_ICON" ]
then
    message "$NEW_ICON does not exist"
else
    message "Copy your desired icon to Emacs.icns"
fi

message "To run a separate Emacs based on the $NEW_APP at the command line do:"
message "$NEW_APP/Contents/MacOS/Emacs &"

