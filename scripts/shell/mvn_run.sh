
OPT_NUM=""
NO_SKT=""
MVN_CMD=""

while [ "$OPT_NUM" != "x" -a  "$OPT_NUM" != "X" ]
do
    echo "1) compile"
    echo "2) clean"
    echo "3) install"
    echo "4) -U"
    echo "5) no -DskipTests"
    echo "x) Exit and run"
    echo -n "Enter Command: "
    read OPT_NUM

    case "$OPT_NUM" in
	'1')
	    MVN_CMD="$MVN_CMD compile"
	    ;;
	'2')
	    MVN_CMD="$MVN_CMD clean"
	    ;;
	'3')
	    MVN_CMD="$MVN_CMD install"
	    ;;
	'4')
	    MVN_CMD="-U $MVN_CMD"
	    ;;
	'5')
	    NO_SKT="1"
	    ;;
	'x|X')
	    break
	    ;;
	default)
	    echo "Invalid Command: '$OPT_NUM'"
	    ;;
    esac
    # if [ "$OPT_NUM" == "x" -o "$OPT_NUM" == "X" ]
    # then
    # 	break
    # fi
done

if [ ! -z "$MVN_CMD" ]
then
    if [ -z "$NO_SKT" ]
    then
       MVN_CMD="$MVN_CMD -DskipTests"
    fi
    set -x
    mvn $MVN_CMD
    set +x
else
    echo "No mvn commands specified - Exiting"
fi
