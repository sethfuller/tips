#!/usr/bin/env zsh

PROP=""
CASEI=""
XML=""

usage()
{
  echo "Usage: grep-find.sh [ -p | --prop ]
                        [ -i | --casei ] 
                        [ -x | --xml   ] match(es)"
  exit 2
}

echo "UNPARSED=$*"

while [ $# -gt 0 ]
do
      echo "opt=$1"
      if [ "$1" = "-p" ]
      then
	  PROP=1
	  shift
      fi
      if [ "$1" = "-i" ]
      then
	  CASEI=1
	  shift
      fi
      if [ "$1" = "-x" ]
      then
	  XML=1
	  shift
      fi
      
done

echo "PROP  : $PROP"
echo "CASEI : $CASEI "
echo "XML   : $XML"

if [ "$PROP" != "" ]
then
    EXCLUDE="properties:"
fi
echo "$EXCLUDE"
if [ "$XML" != "" ]
then
    if [ "$EXCLUDE" != "" ]
    then
	EXCLUDE="$EXCLUDE|"
    fi
echo "$EXCLUDE"
    
    EXCLUDE="${EXCLUDE}xml:"
echo "$EXCLUDE"
fi


set -x
grep -v "$EXCLUDE"
set +x
