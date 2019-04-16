#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
ROOT_DIR="$(realpath "${ROOT_DIR:=${SCRIPT_DIR}}")"
source "${SCRIPT_DIR}/colorize.sh"
source "${SCRIPT_DIR}/common.sh" $@

pushd "${COMPONENTS_DIR}/jupyter" > /dev/null

docker-compose exec jupyter sh -c "cd /home/jovyan/work/${DEMO_NAME}/demo/test; make"

popd > /dev/null
