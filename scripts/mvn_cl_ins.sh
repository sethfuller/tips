
CMD_FLAG=$1
shift
OPTIONS="$*"

CMD=""
if [ "$CMD_FLAG" == "c" ]
then
    CMD="clean"
else
    echo "mvn running without clean\n"
fi
CMD="$CMD install"

set -x
mvn $OPTIONS $CMD -DskipTests

set +x
if [ "$CMD_FLAG" != "c" ]
then
    echo "\nmvn run without clean"
fi
echo "\nmvn Done: $(date)"
