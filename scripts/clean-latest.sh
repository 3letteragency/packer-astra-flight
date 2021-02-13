#!/usr/bin/env bash
set -euxo

sudo apt -y install jq

SNAPSHOT_DESC=$1
SNAPSHOTS=$(curl --silent --location --request GET 'https://api.vultr.com/v2/snapshots' --header "Authorization: Bearer $VULTR_API_KEY" | jq -r --arg SNAPSHOT_DESC "$SNAPSHOT_DESC" '.snapshots[] | select(.description==$SNAPSHOT_DESC).id')

clean_snapshots(){
  for SNAPSHOT in $SNAPSHOTS; do
    echo "+ Deleting $SNAPSHOT"
    curl --silent --location --request DELETE "https://api.vultr.com/v2/snapshots/$SNAPSHOT" --header "Authorization: Bearer $VULTR_API_KEY"
  done
}

main(){
  if [ "$SNAPSHOTS" != "" ]; then
    echo "+ Cleaning snapshots"
    clean_snapshots
    echo "+ Snapshots cleaned"
  else
    echo "+ No snapshots to remove(last build(s) probably failed)"
  fi
}

main
