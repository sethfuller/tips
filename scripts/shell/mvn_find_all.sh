
# Pass in your latest releaase of Java 8
LOGFILE=$1
if [ -z "$LOGFILE" ]
then
    LOGFILE="mvn_test.log"
fi


set -x
fgrep '[INFO] Tests run:' $LOGFILE | grep elapsed | awk -F',' '{print $1, $2, $3, $4, $NF}' |\
    awk 'BEGIN {tot = 0; err=0; fail=0; skip=0} {printf("%4d %4d %4d %4d %s\n", $4, $6, $8, $10, $NF); tot += $4; fail += $6; err += $8; skip += $10} END {printf("Total: %d Fail: %d Err: %d Skip %d\n", tot, fail, err, skip)}'
set +x
