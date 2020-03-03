
ROOTDIR=$1

mkdir -p "$ROOTDIR"

curl -o "$ROOTDIR/standaardenregister.json" https://raw.githubusercontent.com/ddvlanck/OSLO-StandaardenGeneral/master/standaardenregister.json

CURRENT_COMMIT="$(git rev-parse --verify HEAD)"


for file in $(ls -p | grep -v /); do
  if [ $(jq --arg file "$file" -r '.[] | select(.configuration == $file)' "$ROOTDIR/standaardenregister.json") ]
  then
    jq --arg file "$file" --arg COMMIT "$CURRENT_COMMIT" '. | map(if .configuration == $file then . + {"commitHash" : $COMMIT} else . end)' "$ROOTDIR/standaardenregister.json" > "$ROOTDIR/updated-register.json"
  else
    echo "$file is not present in the standards register"
  fi
done

