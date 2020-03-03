
ROOTDIR=$1

mkdir -p "$ROOTDIR"

curl -o "$ROOTDIR/tmp-register.json" https://raw.githubusercontent.com/ddvlanck/OSLO-StandaardenGeneral/master/standaardenregister.json

CURRENT_COMMIT="$(git rev-parse --verify HEAD)"
PREV_COMMIT="$(git rev-parse --verify HEAD~1)"


for file in $(ls -p | grep -v /); do
  if [ $(jq --arg file "$file" -r '.[] | select(.configuration == $file) | .commitHash' "$ROOTDIR/tmp-register.json") ]
  then
    UPDATED_OBJECT=$(jq --arg file "$file" --arg CURRENT_COMMIT "$CURRENT_COMMIT" -r '.[] | select(.configuration == $file) | .commitHash = $CURRENT_COMMIT | tostring' "$ROOTDIR/tmp-register.json")
### TODO: find way to merge new object in array , current method is not working properly
    echo "RESULT: "
    #jq --arg UPDATED_OBJECT "$UPDATED_OBJECT" '. |= .+ [$UPDATED_OBJECT]' "$ROOTDIR/tmp-register.json" > "$ROOTDIR/tmp.json"
    jq --arg UPDATED_OBJECT "$UPDATED_OBJECT" '. + $UPDATED_OBJECT | unique_by(.configuration)' "$ROOTDIR/tmp-register.json" > "$ROOTDIR/tmp.json"
    cat "$ROOTDIR/tmp.json"

##TODO: UPDATED OBJECT SHOULD BE FORMATTED

    echo "$file was changed and is present"
  else
    echo "$file was changed and not present"
  fi
done

echo "IM DONE"

#while read file; do

# echo "$file changed";
  #if [ $(jq -r '.[] | select(.configuration == "$file") | .commitHash' "$ROOTDIR/tmp-register.json") -ne "" ]
  #then
  #  echo "$file was changed and is also used as configuration file in standards register"
  #else
  #  echo "$file was changed, but is not in standards register"
  #fi
#done < "$changedFiles"
