#!/bin/bash
set -e

show_usage() {
    echo "Usage: ${0##*/} [--repo=URL] [--dir=PATH] packages..."
    echo "    --repo=URL   Maven repo URL. Default=maven-central"
    echo "    --dir=PATH   Directory where jars are dowloaded. Default=CWD"
}

show_info() {
    echo "---------------------- INFO ----------------------"
    echo "REPO=${REPO}"
    echo "DIR=${DIR:-$PWD}"
    echo "PACKAGES=..."
    for package in "${PACKAGES[@]}"; do
        echo "  * [${package}]"
    done
    echo "--------------------------------------------------"
}

while [ "$1" != "" ]; do
    case $1 in
        -h|-\?|--help)
            show_usage
            exit
            ;;
        --repo=?*)
            REPO=${1#*=}
            ;;
        --dir=?*)
            DIR=${1#*=}
            ;;
        -?*)
            echo >&2 "[ERROR] Unknown option (ignored): $1"
            ;;
        *)
            break
    esac
    shift
done

if [ "${REPO:-maven-central}" == "maven-central" ]; then
    REPO="http://central.maven.org/maven2"
else
    REPO="${REPO%/}" # removing tail slash
fi
if [ -n "${DIR}" ]; then
    if [ ! -d "${DIR}" ]; then
        echo >&2 "[ERROR] Directory ${DIR} is NOT exists."
        exit 1
    else
        cd "${DIR}"
    fi
fi
PACKAGES=( "$@" )
if [ ${#PACKAGES[@]} -le 0 ]; then
    echo >&2 "[ERROR] Package names are required."
    echo >&2 "[ERROR] Run '${0##*/} --help' for more infomantion."
    exit 1
fi
show_info

get_link() {
    package=$1
    IFS=':' read -ra parts <<< "$package"
    if [ ${#parts[@]} -ne 3 ]; then
        echo >&2 "[ERROR] Package must have exactly 3 parts, seperated by a colon."
        echo >&2 "[ERROR] Like: vn.teko.bigdata:spark-package:1.0"
        echo >&2 "[ERROR] Got:  ${package}"
        exit 1
    fi

    group=${parts[0]}
    artifact=${parts[1]}
    version=${parts[2]}

    echo "${REPO}/${group//\./\/}/${artifact}/${version}/${artifact}-${version}.jar"
}

download_packages() {
    declare -a links
    for package in "${PACKAGES[@]}"; do
        url=$(get_link $package)
        links+=( "$url" )
    done

    if   command -v curl > /dev/null 2>&1; then
        DL="curl -L --remote-name-all"
    elif command -v wget > /dev/null 2>&1; then
        DL="wget"
    else
        echo >&2 "[ERROR] Both curl, wget not found."
        exit 1
    fi
    $DL "${links[@]}"
}
download_packages
