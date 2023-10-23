combined_average=$1
if [ -z "$combined_average" ]
then
    echo "Usage: $0 combined_avererage (e.g. 15.543)"
    exit 1
fi

   ########### START XQUBE coverage generation ###########

   DIR_PATH="$HOME/logg"

  combined_average_dec=$(awk "BEGIN {printf \"%.6f\", ${combined_average}/100}")

  DT="$(date '+%Y%m%d%H%M')"
  FILE_NAME="PCT_${DT}"
  if [ ! -z "$BUILD_ID" ]
  then
      $FILE_NAME="${FILE_NAME}_${BUILD_ID}"
  fi
  COUNT=0
  FN="${DIR_PATH}/${FILE_NAME}.log"

  unset -v latest
  for file in "$DIR_PATH"/*; do
      [[ $file -nt "$latest" ]] && latest=$file
  done

  if [ ! -z "$latest" ]
  then
      PCT_VAL="$(cat $latest)"
  else
      PCT_VAL=0
  fi
  # echo "PCT_VAL='$PCT_VAL' combined_average_dec='$combined_average_dec'"

  # set -x
  NOT_EQ=$(echo "$PCT_VAL != $combined_average_dec" |bc -l)

  if [ "$NOT_EQ" -ne 0 ]
  then
      while [ -f "$FN" ]
      do
          COUNT=$((COUNT+1))
          FN="${DIR_PATH}/${FILE_NAME}_${COUNT}.log"
      done

      echo "$combined_average_dec" > $FN
  fi

  find $DIR_PATH -name 'PCT_*' -type f -ctime +1d -exec rm {} \;

  ########### END XQUBE coverage generation ###########
  
