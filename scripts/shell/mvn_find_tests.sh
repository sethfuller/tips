
# Pass in your latest releaase of Java 8
LOGFILE=$1
if [ -z "$LOGFILE" ]
then
    LOGFILE="mvn_test.log"
fi


set -x
fgrep '[WARNING] Tests run' $LOGFILE | grep -v elapsed
set +x
