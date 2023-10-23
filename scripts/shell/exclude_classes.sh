PREFIX=$1

if [ -z "$PREFIX" ]
then
    echo "Usage: prefix"
    exit 1
fi

echo "" > ${PREFIX}_exclude.out

if [ -f "${PREFIX}_cannot_test.out" ]
then
    cat ${PREFIX}_cannot_test.out >> ${PREFIX}_exclude.out
fi

if [ -f "${PREFIX}_deprecated.out" ]
then
    cat ${PREFIX}_deprecated.out >> ${PREFIX}_exclude.out
fi

if [ -f "${PREFIX}_trivial.out" ]
then
    cat ${PREFIX}_trivial.out >> ${PREFIX}_exclude.out
fi

          
if [ -f "${PREFIX}_tested.out" ]
then
    cat ${PREFIX}_tested.out >> ${PREFIX}_exclude.out
fi
