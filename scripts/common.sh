#!/bin/bash -e
function die() {
    printf '%s\n' "$1" >&2
    exit 1
}

################### SHOW USAGE ###################
function show_usage() {
    echo "Usage: ${0##*/} "
    echo "    --demo=DEMO   Required. Run JupyterLab with given demo"
    echo "    --purge       Purge network, volumes and orphans containers. Only effect when run 'down' command"
}

################### PARSE ARGS ###################
unset MODE_NAME
unset DEMO_NAME
while [ "$1" != "" ]; do
    case $1 in
        -h|-\?|--help)
            show_usage
            exit
            ;;
        --demo=?*)
            DEMO_NAME=${1#*=}
            ;;
        --purge)
            PURGE=true
            ;;
        -?*)
            echo "!!! WARN !!!: Unknown option (ignored): $1"
            ;;
        *)
            break
    esac
    shift
done

################### CHECK REQUIREMENTS ###################
if [ -z "${DEMO_NAME}" ]; then
    [   -z "${DLF_DIR}" ] && die "${red}!!! ERROR !!! --demo=DEMO is required${normal}"
else
    DEMO_DIR="$(realpath "${DEMO_DIR:=${ROOT_DIR}/demos/${DEMO_NAME}/demo}")"
    DEMO_RC_FILE="$(realpath "${DEMO_RC_FILE:=${ROOT_DIR}/demos/${DEMO_NAME}/docker.env}")"
    [ ! -d "${DEMO_DIR}" ]     && die "${red}!!! ERROR !!! Demo directory ${DEMO_DIR} does NOT EXIST${normal}"
    [ ! -f "${DEMO_RC_FILE}" ] && die "${red}!!! ERROR !!! Demo RC file ${DEMO_RC_FILE} does NOT EXIST${normal}"

    export DEMO_NAME
    export DEMO_DIR
    export DEMO_RC_FILE
fi

COMPONENTS_DIR="$(realpath "${COMPONENTS_DIR:=${ROOT_DIR}/docker/compose}")"
if [ ! -d "${COMPONENTS_DIR}" ]; then
    die "${red}!!! ERROR !!! Components directory ${COMPONENTS_DIR} does NOT EXIST${normal}"
fi
export > /dev/null

################### SHOW USAGE ###################
function show_info() {
    echo "============================= INFO ============================="
    echo "ROOT_DIR       = ${ROOT_DIR}"
    echo "DEMO_NAME      = ${DEMO_NAME}"
    echo "DEMO_DIR       = ${DEMO_DIR}"
    echo "DEMO_RC_FILE   = ${DEMO_RC_FILE}"
    echo "COMPONENTS_DIR = ${COMPONENTS_DIR}"
    echo "================================================================"
}
show_info
