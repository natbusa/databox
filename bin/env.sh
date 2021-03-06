#!/bin/bash -e

SCRIPT_DIR="$(dirname "$(realpath -s "${BASH_SOURCE}")")"
ROOT_DIR="$(realpath "${ROOT_DIR:=${SCRIPT_DIR}/..}")"
REQUIREMENTS=(make curl git docker docker-compose)

function die() {
    printf "\n${BASH_SOURCE}:\n"
    printf '%s\n' "$@" >&2
    echo
    exit 1
}

################### SHOW USAGE ###################
function show_help() {
    echo "Usage: ${0##*/} "
    echo "    up|down|purge|test <demo_name> execute the given command on <demo_name>"
    echo "    -h|--help print this help"
}

################### SHOW USAGE ###################
function show_info() {
    echo "============================= INFO ============================="
    echo "ROOT_DIR        = ${ROOT_DIR}"
    echo "COMPONENTS_DIR  = ${COMPONENTS_DIR}"
    echo "DEMO_NAME       = ${DEMO_NAME}"
    echo "DEMO_CMD        = ${DEMO_CMD}"
    echo "DEMO_DIR        = ${DEMO_DIR}"
    echo "DEMO_RC_FILE    = ${DEMO_RC_FILE}"
    echo "DEMO_REPO_URL   = ${DEMO_REPO_URL}"
    echo "DEMO_COMPONENTS = ${DEMO_COMPONENTS[*]}"
    echo "================================================================"
}

function show_urls() {
    echo "============================= URLs ============================="
    echo "PostgreSQL        = postgresql://postgres:5432"
    echo "                  = postgresql://127.0.0.1:5432"
    echo "MySQL             = mysql://mysql:3306"
    echo "                  = mysql://127.0.0.1:3306"
    echo "MSSQL             = sqlserver://mssql:3306"
    echo "                  = sqlserver://127.0.0.1:1433"
    echo "ClickHouse        = clickhouse://clickhouse:9999"
    echo "                  = clickhouse://127.0.0.1:9999"
    echo "Hive              = jdbc:hive2://hive-thriftserver:10000"
    echo "                  = jdbc:hive2://127.0.0.1:10000"
    echo "Oracle            = jdbc:oracle:thin:@//oracle:1521"
    echo "                  = jdbc:oracle:thin:@//127.0.0.1:1521"
    echo "Minio             = s3a://minio:9000"
    echo "                  = http://127.0.0.1:9000"
    echo "HDFS              = hdfs://hdfs-namenode:8020"
    echo "HDFS (web UI)     = http://127.0.0.1:9870"
    echo "Spark             = spark://spark-master:7077"
    echo "Spark (web UI)    = http://127.0.0.1:8080"
    echo "ElasticSearch     = elasticsearch:9300"
    echo "Kibana            = http://127.0.0.1:5601"
    echo "Zookeeper         = zookeeper:2181"
    echo "Kafka             = kafka:9092"
    echo "JupyterLab        = http://127.0.0.1:8888"
    echo "================================================================"
}

function start_components() {
  # start network if not started yet
  if ! docker network inspect databox > /dev/null 2>&1; then
      docker network create databox
  fi

  # start components
  for component in ${DEMO_COMPONENTS[*]}
  do
    if [ ! -d "${COMPONENTS_DIR}/${component}" ]; then
        die "${BASH_SOURCE}: Component '${component}' does not exists in ${COMPONENTS_DIR}"
    fi
    pushd "${COMPONENTS_DIR}/${component}" > /dev/null
    docker-compose up -d
    popd > /dev/null
  done
}

################### STOP DLF COMPONENTS ###################
function stop_components() {
  if [ -n "${PURGE}" ]; then
      PURGE_ARGS="--volumes --remove-orphans"
  fi

  for component in ${DEMO_COMPONENTS[*]}
  do
    if [ -d "${COMPONENTS_DIR}/${component}" ]; then
      pushd "${COMPONENTS_DIR}/${component}" > /dev/null
      docker-compose down ${PURGE_ARGS}
      popd > /dev/null
    fi
  done

  # bring down network if necessary
  if [ -n "${PURGE}" ]; then
    if docker network inspect databox > /dev/null 2>&1; then
        docker network rm databox
    fi
  fi
}

################### TEST  ###################
function test_demo() {
  pushd "${COMPONENTS_DIR}/jupyter" > /dev/null
  docker-compose exec jupyter sh -c "cd /home/jovyan/work/${DEMO_NAME}/demo/test; make"
  popd > /dev/null
}

################### PARSE ARGS ###################
unset DEMO_NAME
unset DEMO_CMD

while [[ $# -gt 0 ]]
do
key="$1"
case $key in
    -d|--demo)
      DEMO_NAME="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    up|down)
      DEMO_CMD="$1"
      shift # past argument
      ;;
    purge)
      DEMO_CMD="down"
      PURGE=true
      shift # past argument
      ;;
    test)
      DEMO_CMD="test"
      shift # past argument
      ;;
    -?*)
      echo "Unknown option (ignored): $1"
      shift # past argument
      ;;
    *)
      DEMO_NAME="$1" # positional params as DEMO_NAME
      shift # past argument
      ;;
esac
done

# which action?
if [ -z "${DEMO_CMD}" ]; then
  die "Error: must specify an action to execute. For help use -h or --help"
fi

# which demo?
if [ -z "${DEMO_NAME}" ]; then
    die "Error: No demo name provided. For help use -h or --help"
fi

# defaults
DEMO_RC_FILE="${DEMO_RC_FILE:=${ROOT_DIR}/demos/${DEMO_NAME}/config.rc}"
DEMO_DIR="${DEMO_DIR:=${ROOT_DIR}/demos/${DEMO_NAME}/demo}"

################### CHECK TOOLS REQUIREMENTS ###################
for toolname in $REQUIREMENTS
do
  [ "$(which ${toolname})" ] || die "Error: ${toolname} required for this environment. " "Run ${ROOT_DIR}/bin/install.sh"
done

################### CHECK DEMO CONFIGURATION ###################

## DEMO RC_FILE
[ ! -f "${DEMO_RC_FILE}" ] && die "Error: No configuration file provided for ${DEMO_NAME}:" "File ${DEMO_RC_FILE} does not exists"
eval $(sed -e 's/#.*$//' -e '/^$/d' ${DEMO_RC_FILE})

## DEMO DIRECTORY
if [ ! -d "${DEMO_DIR}" ]; then
  echo "Cloning Demo ${DEMO_NAME} from ${DEMO_REPO_URL}"
  git clone ${DEMO_REPO_URL} ${DEMO_DIR} || die "Error: could not git clone the demo from repository ${DEMO_REPO_URL} "
fi

## DOCKER COMPONENTS DIRECTORY
COMPONENTS_DIR="${COMPONENTS_DIR:=${ROOT_DIR}/docker/compose}"
if [ ! -d "${COMPONENTS_DIR}" ]; then
    die "Error: Components directory ${COMPONENTS_DIR} does NOT EXIST"
fi

# these two are passed to the docker-compose.yml
export DEMO_NAME
export DEMO_DIR

## show configuration
show_info

## execute action
case $DEMO_CMD in
  up)
    start_components
    show_urls
    ;;
  down|purge)
    stop_components
    ;;
  test)
    start_components
    test_demo
    stop_components
    ;;
  *)
    die "Command $DEMO_CMD Not implemented"
esac
