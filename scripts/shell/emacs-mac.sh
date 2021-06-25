
# PROFILE=$1
# if [ -z "$PROFILE" ]
# then
#     PROFILE="default"
#     shift
# fi

message() {
    echo $*
    echo ""
}

PARSED_ARGS=$(getopt p:d $*)
VALID_ARGUMENTS=$?

if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

set -- $PARSED_ARGS

DEFAULT_PROFILE=""
for opt
do
    case "$opt"
    in
        -p)
            PROFILE="$2"; shift;
            shift;;
        -d)
            DEFAULT_PROFILE="1"
            shift;;
        --)
            shift; break;;
    esac
done

if [ ! -z "$DEFAULT_PROFILE" ]
then
    PROFILE="default"
fi

EMACS_ARGS=""

if [ ! -z "$PROFILE" ]
then
    EMACS_ARGS="--with-profile $PROFILE"
fi

for VERSION in $*
do
    EMACS_APP="/Applications/Emacs${VERSION}.app/Contents/MacOS/Emacs"
    if [ -f "$EMACS_APP" ]
    then
        echo "START: $EMACS_APP $EMACS_ARGS &"
        $EMACS_APP $EMACS_ARGS &
    else
        echo "$EMACS_APP - DOES NOT EXIST"
    fi
done

