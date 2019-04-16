#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"

################### BUILD CONTAINERS ###################
pushd $SCRIPT_DIR
for c in $(ls)
do
  pushd $c && make build && popd
done
popd
