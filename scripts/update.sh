
ROOTDIR=$1

mkdir -p "$ROOTDIR"

curl -o "$ROOTDIR/standaardenregister.json" https://raw.githubusercontent.com/ddvlanck/OSLO-StandaardenGeneral/master/standaardenregister.json

CURRENT_COMMIT="$(git rev-parse --verify HEAD)"
PREV_COMMIT="$(git rev-parse --verify HEAD~1)"

echo "Old commit hash is: $PREV_COMMIT"
echo "New commit hash is: $CURRENT_COMMIT"


for file in $(ls -p | grep -v /); do
  if [ $(jq --arg file "$file" -r '.[] | select(.configuration == $file) | .commitHash' "$ROOTDIR/standaardenregister.json") ]
  then
    jq --arg file "$file" --arg COMMIT "$CURRENT_COMMIT" '. | map(if .configuration == $file then . + {"commitHash" : $COMMIT} else . end)' "$ROOTDIR/standaardenregister.json" > "$ROOTDIR/updated-register.json"
    echo "Printing standards register"
    cat "$ROOTDIR/standaardenregister.json"
    echo "===================="
    echo "Printing tmp file"
    cat "$ROOTDIR/updated-register.json"
  else
    echo "$file is not present in the standards register"
  fi
done


