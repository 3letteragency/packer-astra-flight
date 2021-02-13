#!/usr/bin/env bash
set -euxo pipefail

source ../secrets.env
source ../project.env

export GAME_ARCHIVE_URL=$(s3cmd -c $ASTRA_S3_CFG signurl $ASTRA_ASSETS_BUCKET/$S3_GAME_ARCHIVE_PREFIX/$KSP_TAR_FILENAME $(date -d 'today + 1 day' +%s))
export CKAN_VERSION="1.28.0"
export CKAN_DEB_URL=$(echo "https://github.com/KSP-CKAN/CKAN/releases/download/v${CKAN_VERSION}/ckan_${CKAN_VERSION}_all.deb")
export KRPC_VERSION="0.4.9.1"
export KRPC_ZIP_URL=$(echo "https://github.com/haeena/krpc/releases/download/v${KRPC_VERSION}/krpc-${KRPC_VERSION}.zip")
export AUTOLOADGAME_VERSION="1.0.10"
export AUTOLOADGAME_ZIP_URL=$(echo "https://github.com/allista/AutoLoadGame/releases/download/v${AUTOLOADGAME_VERSION}/AutoLoadGame-v${AUTOLOADGAME_VERSION}.zip")
export S3_PRINCIPIA_PREFIX="principia"
export PRINCIPIA_CODENAME="galois"
export PRINCIPIA_KSP_VERSION="1.9.1"
export PRINCIPIA_ZIP_FILENAME="principia-${PRINCIPIA_CODENAME}-${PRINCIPIA_KSP_VERSION}.zip"
export PRINCIPIA_ZIP_URL=$(s3cmd -c $ASTRA_S3_CFG signurl $ASTRA_ASSETS_BUCKET/$S3_PRINCIPIA_PREFIX/$PRINCIPIA_ZIP_FILENAME $(date -d 'today + 1 day' +%s))

validate(){
    packer validate astra.json
}

build(){
    packer build astra.json
}

main(){
    validate
    build
}

main
