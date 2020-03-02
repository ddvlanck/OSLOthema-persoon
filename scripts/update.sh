
ROOTDIR=$1

mkdir -p "$ROOTDIR"

curl -o /tmp/workspace/tmp-register.json https://raw.githubusercontent.com/ddvlanck/OSLO-StandaardenGeneral/master/standaardenregister.json

CURRENT_COMMIT= "$(git rev-parse --verify HEAD)"
PREV_COMMIT="$(git log -n2 --format=format:"%H")"

changedFiles="$(git diff --name-only $PREV_COMMIT)"

while read -r file; do
  jq -r '.[] | select(.configuration == "vocabularium-melding.jn") | .commitHash' standaardenregister.json

  if [ $(jq -r '.[] | select(.configuration == "$file") | .commitHash' standaardenregister.json) -ne "" ]
  then
    echo "$file was changed and is also used as configuration file in standards register"
  else
    echo "$file was changed, but is not in standards register"
  fi
done < changedFiles
