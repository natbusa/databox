#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
ROOT_DIR="$(realpath "${ROOT_DIR:=${SCRIPT_DIR}}")"

source "${SCRIPT_DIR}/colorize.sh"
source "${SCRIPT_DIR}/common.sh" $@

################### STOP DLF COMPONENTS ###################
function teardown_component() {
    local com=$1

    if [ -n "${PURGE}" ]; then
        PURGE_ARGS="--volumes --remove-orphans"
    fi

    if [ -d "${COMPONENTS_DIR}/${com}" ]; then
      pushd "${COMPONENTS_DIR}/${com}" > /dev/null
      docker-compose down ${PURGE_ARGS}
      popd > /dev/null
    fi
}

while read -r line; do
    # ignore empty & commented lines
    if [[ -z "$line" ]] || [[ "$line" =~ ^#.*$ ]]; then
        continue
    fi
    teardown_component "${line}"
done < "${DEMO_RC_FILE}"

################### DELETE DLF NETWORK ###################
if [ -n "${PURGE}" ]; then
    if docker network inspect datalabframework > /dev/null 2>&1; then
        docker network rm datalabframework
    fi
fi
