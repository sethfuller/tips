
# JAVA_DEFUALT=

# if [ -z "$JAVA_DEFAULT" ]
# then
    JAVA_DEFAULT="11"
# fi

export JAVA_HOME="$(/usr/libexec/java_home -v ${JAVA_DEFAULT})"

if [[ -o interactive ]]
then
    echo "JAVA_HOME=$JAVA_HOME"
fi

