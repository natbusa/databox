#!/bin/bash -e
SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
ROOT_DIR="$(realpath "${ROOT_DIR:=${SCRIPT_DIR}}")"

source "${SCRIPT_DIR}/colorize.sh"
source "${SCRIPT_DIR}/common.sh" $@

################### CREATE DLF NETWORK ###################
if ! docker network inspect datalabframework > /dev/null 2>&1; then
    docker network create datalabframework
fi

################### START DLF COMPONENTS ###################
function startup_component() {
    local com=$1
    if [ ! -d "${COMPONENTS_DIR}/${com}" ]; then
        die "${red}!!! ERROR !!! Component '${com}' does NOT EXIST at directory ${COMPONENTS_DIR}${normal}"
    fi
    pushd "${COMPONENTS_DIR}/${com}" > /dev/null
    docker-compose up -d
    popd > /dev/null
}

while read -r line; do
    # ignore empty & commented lines
    if [[ -z "$line" ]] || [[ "$line" =~ ^#.*$ ]]; then
        continue
    fi
    startup_component "${line}"
done < "${DEMO_RC_FILE}"

################### SHOW URLs ###################
function show_urls() {
    echo "============================= URLs ============================="
    echo "${green}PostgreSQL${normal}        = ${blue}postgresql://postgres:5432${normal}"
    echo "                  = ${magenta}postgresql://127.0.0.1:5432${normal}"
    echo "${green}MySQL${normal}             = ${blue}mysql://mysql:3306${normal}"
    echo "                  = ${magenta}mysql://127.0.0.1:3306${normal}"
    echo "${green}MSSQL${normal}             = ${blue}sqlserver://mssql:3306${normal}"
    echo "                  = ${magenta}sqlserver://127.0.0.1:1433${normal}"
    echo "${green}Hive${normal}              = ${blue}jdbc:hive2://hive-thriftserver:10000${normal}"
    echo "                  = ${magenta}jdbc:hive2://127.0.0.1:10000${normal}"
    echo "${green}MongoDB${normal}           = ${blue}mongo://mongo:27017${normal}"
    echo "                  = ${magenta}mongo://127.0.0.1:27017${normal}"
    echo "${green}Minio${normal}             = ${blue}s3a://minio:9000${normal}"
    echo "                  = ${magenta}http://127.0.0.1:9000${normal}"
    echo "${green}HDFS${normal}              = ${blue}hdfs://hdfs-namenode:8020${normal}"
    echo "${green}HDFS (web UI)${normal}     = ${magenta}http://127.0.0.1:9870${normal}"
    echo "${green}Spark${normal}             = ${blue}spark://spark-master:7077${normal}"
    echo "${green}Spark (web UI)${normal}    = ${magenta}http://127.0.0.1:8080${normal}"
    echo "${green}ElasticSearch${normal}     = ${blue}elasticsearch:9300${normal}"
    echo "${green}Kibana${normal}            = ${magenta}http://127.0.0.1:5601${normal}"
    echo "${green}Zookeeper${normal}         = ${blue}zookeeper:2181${normal}"
    echo "${green}Kafka${normal}             = ${blue}kafka:9092${normal}"
    echo "${green}JupyterLab${normal}        = ${magenta}http://127.0.0.1:8888${normal}"
    echo "================================================================"
}
show_urls
