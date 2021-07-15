#!/usr/bin/env bash
##^ ## Author: Seth Fuller
##^ ## Date: 14-July-2021
##^
##% Get sources and/or javadoc for an artifact
##% 
##% Usage: mvn_get_src_jd.sh -s -j -g group_id -a artifact_id
##% -s - Get sources (default - must be used if sources and javadoc are desired)
##% -j - Get Javadoc
##% -a artifact_id - Specify Artifact ID
##% -g group_id    - Specify Group ID
##%
##% if -a is specified -g must be specified

usage() {

    grep '##% ' $0 |grep -v grep |sed 's/^\#\#\% //'

    exit 1
}

message() {
    echo $*
    echo ""
}

PARSED_ARGS=$(getopt sja:g: $*)
VALID_ARGUMENTS=$?

if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

set -- $PARSED_ARGS

GET_SRCS=""
GET_JD=""

for OPT
do
#    echo "OPT=$OPT 2=$2"
    case "$OPT"
    in
        -s)
            GET_SRCS="1"
            shift;;
        -s)
            GET_JD="1"
            shift;;
        -a)
            # echo icon is "'"$2"'"
            ARTIFACT_ID="$2"; shift;
            shift;;
        -g)
            # echo icon is "'"$2"'"
            GROUP_ID="$2"; shift;
            shift;;
        --)
            shift; break;;
    esac
done

if [ -z "$ARTIFACT_ID" -a ! -z "$GROUP_ID" ]
then
    message "No artifact specified, but group specified"
    usage
fi

if [ ! -z "$ARTIFACT_ID" -a  -z "$GROUP_ID" ]
then
    message "No group specified, but artifact specified"
    usage
fi

if [ -z "$GET_SRCS" -a -z "$GET_JD" ]
then
    GET_SRCS="1"
fi

MVN_ARGS=""

if [ "$GET_SRCS" ]
then
    MVN_ARGS="dependency:sources"
fi

if [ "$GET_JD" ]
then
    MVN_ARGS="$MVN_ARGS dependency:resolve -Dclassifier=javadoc"
fi

if [ ! -z "$ARTIFACT_ID" ]
then
    MVN_ARGS="$MVN_ARGS -DincludeGroupIds=$GROUP_ID -DincludeArtifactIds=$ARTIFACT_ID"
fi

MVN_CMD="mvn $MVN_ARGS"

# echo "$MVN_CMD"

set -x

$MVN_CMD

set +x
