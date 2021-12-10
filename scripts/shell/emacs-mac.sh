
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

PARSED_ARGS=$(getopt p:nd $*)
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
        -n)
            NUM_PROFILE="1"
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

for VERSION in $*
do
    if [ ! -z "$NUM_PROFILE" ]
    then
        PROFILE="emacs-${VERSION}"
    fi

    if [ ! -z "$PROFILE" ]
    then
        EMACS_ARGS="--with-profile $PROFILE"
    fi

    EMACS_APP="/Applications/Emacs${VERSION}.app/Contents/MacOS/Emacs"
    # Use this on M1 Macs
    # EMACS_APP="/Applications/Emacs${VERSION}.app/Contents/MacOS/Emacs-x86_64-10_14"

    if [ -f "$EMACS_APP" ]
    then
        echo "START: $EMACS_APP $EMACS_ARGS &"
        $EMACS_APP $EMACS_ARGS &
    else
        echo "$EMACS_APP - DOES NOT EXIST"
    fi
done
