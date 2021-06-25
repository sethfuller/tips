#!/usr/bin/env bash
##^ ## Author: Seth Fuller
##^ ## Date: 25-June-20201

usage() {
    echo "Usage: $0 new_app_full_path [new_icon_path] [orig_app_full_path - Defaults to /Applications/Emacs.app]"
    echo "The new_icon_path is the .icns file that will replace Emacs.icns in /Applications/<new_app>/Countents/Resources\n"
    
}

NEW_APP=$1
NEW_ICON=$2
ORIG_APP=$3

if [ -z "$NEW_APP" ]
then
    usage
    exit 1
fi

if [ -z "$ORIG_APP" ]
then
    ORIG_APP="/Applications/Emacs.app/"
fi

if [[ ! "$NEW_APP" =~ .app$ ]]
then
    NEW_APP="${NEW_APP}.app"
fi

if [[ ! "$NEW_APP" =~ ^/Applications ]]
then
    NEW_APP="/Applications/${NEW_APP}"
fi

if [[ ! "$ORIG_APP" =~ .app$ ]]
then
    ORIG_APP="${ORIG_APP}.app"
fi

if [[ ! "$ORIG_APP" =~ ^/ ]]
then
    ORIG_APP="/Applications/${ORIG_APP}"
fi

mkdir -pv "${NEW_APP}/Contents/Resources"

cd ${NEW_APP}/Contents

echo "Linking files/dirs in ${ORIG_APP}/Contents/ to ${NEW_APP}/Contents"
echo "This will cause will say Resources exists, that is OK"

ln -s ${ORIG_APP}/Contents/* .

cd ${NEW_APP}/Contents/Resources

ln -s ${ORIG_APP}/Contents/Resources/* .

if [ ! -z "$NEW_ICON" -a -f "$NEW_ICON" ]
then
    echo "Copying $NEW_ICON to ${NEW_APP}/Contents/Resources/Emacs.icns"
    rm ${NEW_APP}/Contents/Resources/Emacs.icns
    cp $NEW_ICON Emacs.icns
elif [ ! -z "$NEW_ICON" -a ! -f "$NEW_ICON" ]
then
    echo "$NEW_ICON does not exist"
else
    echo "In ${NEW_APP}/Contents/Resources remove link to Emacs.icns"
    echo "Copy your desired icon to Emacs.icns"
fi

set +x

