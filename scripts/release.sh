#!/usr/bin/env bash
set -euxo

sudo apt -y install jq

SNAPSHOT_DESC=$1
RELEASE=$2
SNAPSHOTS=$(curl --silent --location --request GET 'https://api.vultr.com/v2/snapshots' --header "Authorization: Bearer $VULTR_API_KEY" | jq -r --arg SNAPSHOT_DESC "$SNAPSHOT_DESC" '.snapshots[] | select(.description==$SNAPSHOT_DESC)' | jq --slurp)
echo $SNAPSHOTS | jq
SNAPSHOT_COUNT=$(echo $SNAPSHOTS | jq length)

if [ $SNAPSHOT_COUNT -ne 1 ]; then
  echo "+ No snapshot to promote or too many snapshots, check Astra account"
  exit 1
fi

SNAPSHOT=$(echo $SNAPSHOTS | jq '.[0]')
echo $SNAPSHOT | jq
SNAPSHOT_ID=$(echo $SNAPSHOT | jq -r '.id')
SNAPSHOT_DESCRIPTION=$(echo $SNAPSHOT | jq -r '.description')

if [ "$SNAPSHOT_DESCRIPTION" != "$SNAPSHOT_DESC" ]; then
  echo "+ Cannot promote, snapshot is not a latest. Description: $SNAPSHOT_DESCRIPTION, ID: $SNAPSHOT_ID"
  exit 1
fi

PAYLOAD=$(echo "{ \"description\": \"astra-flight-$RELEASE\" }")
echo $PAYLOAD

echo "+ Promoting $SNAPSHOT to release $RELEASE"
curl --silent --location --request PUT "https://api.vultr.com/v2/snapshots/$SNAPSHOT_ID" --header "Authorization: Bearer $VULTR_API_KEY" --data "$PAYLOAD"
curl --silent --location --request GET "https://api.vultr.com/v2/snapshots/$SNAPSHOT_ID" --header "Authorization: Bearer $VULTR_API_KEY" | jq
