
ROOTDIR=$1

mkdir -p "$ROOTDIR"

curl -o "$ROOTDIR/tmp-register.json" https://raw.githubusercontent.com/ddvlanck/OSLO-StandaardenGeneral/master/standaardenregister.json

CURRENT_COMMIT="$(git rev-parse --verify HEAD)"
PREV_COMMIT="$(git rev-parse --verify HEAD~1)"

changedFiles="$(git diff --name-only "$PREV_COMMIT")"

while read -r file; do

  if [ $(jq -r '.[] | select(.configuration == "$file") | .commitHash' "$ROOTDIR/tmp-register.json") -ne "" ]
  then
    echo "$file was changed and is also used as configuration file in standards register"
  else
    echo "$file was changed, but is not in standards register"
  fi
done < "$changedFiles"
