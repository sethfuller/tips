#!/usr/bin/env bash
##^ ## Author: Seth Fuller
##^ ## Date: 25-June-2021
##^
##^ ## This script will create a new EmacsX.app with links from the original Emacs.app
##^ ## The main purpose is to create another EmacsX.app that can be run separately with a different icon
##^ ## The Emacs Plus Homebrew project has many good icons in the icons directory.
##^ ## The Git repository is: https://github.com/d12frosted/homebrew-emacs-plus.git

##% If new_app_path or orig_app_path do not begin with a '/' /Applications/ will be prepended to them
##% If new_app_path or orig_app_path do not end with '.app' .app will be appended to them
##% -i /path/to/icon/file (Optional)
##% -o /path/to/original/app (Optional - Defaults to /Applications/Emacs.app)
##% -n - Don't delete Emacs.icns
##% 
##% You cannot specify -i and -n at the same time
##% 
##% A valid command line could be:
##% 

usage() {

    message "Usage: $0 new_app_path [-n] [-i new_icon_path] [-o orig_app_path]"
    grep '##% ' $0 |grep -v grep |sed 's/^\#\#\% //'

    message "$0 Emacs2 -i /path/to/icon/file -o Emacs"

    exit 1
}

message() {
    echo $*
    echo ""
}

NEW_APP=$1
shift

PARSED_ARGS=$(getopt ni:o: $*)
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

NO_DEL_ICON=""
for i
do
#    echo "i=$i 2=$2"
    case "$i"
    in
        -i)
            # echo icon is "'"$2"'"
            NEW_ICON="$2"; shift;
            shift;;
        -n)
            # echo icon is "'"$2"'"
            NO_DEL_ICON="1"
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

if [ ! -z "$NO_DEL_ICON" -a ! -z "NEW_ICON" ]
then
    echo "Both -n (no delete icon) and -i /path/to/icon/file were specified. These are incompatible"
    usage
fi

if [ ! -d "$ORIG_APP" ]
then
    message "$ORIG_APP does not exist"
    usage
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

if [ -z "$NO_DEL_ICONS" ]
then
    message "Removing ${NEW_APP}/Contents/Resources/Emacs.icns a link to ${ORIG_APP}/Contents/Resources/Emacs.icns"
    rm ${NEW_APP}/Contents/Resources/Emacs.icns
else
    echo "No deleting ${NEW_APP}/Contents/Resources/Emacs.icns"
    message "You will have to delete it (it is a symlink) before copying icon"
fi

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

