#!/bin/bash
set -eu

function start_metastore() {
    # Init MetaStore database
    # connection="$(xmllint --xpath '/configuration/property[name[text()="javax.jdo.option.ConnectionURL"]]/value/text()' ${HIVE_HOME}/conf/hive-site.xml)"
    {
        echo "=================== Try init metastore database ==================="
        schematool -initSchema -dbType "${DB_TYPE:-postgres}"
    } || {
        echo "================= Try upgrade metastore database =================="
        schematool -upgradeSchema -dbType "${DB_TYPE:-postgres}"
    }

    # Init Warehouse dir
    echo "======================== Init warehouse dir ======================="
    warehouse="$(xmllint --xpath '/configuration/property[name[text()="hive.metastore.warehouse.dir"]]/value/text()' ${HIVE_HOME}/conf/hive-site.xml || echo '')"
    hadoop fs -mkdir -p ${warehouse:-/user/hive/warehouse}

    echo "================== Start hive-metastore service ==================="
    hive --service metastore
}

function start_hiveserver2() {
    hive --service hiveserver2
}

subcmd=$1
shift

case ${subcmd} in
    metastore)
        start_metastore
    ;;
    hiveserver2)
        start_hiveserver2
    ;;
    *)
        echo "Unknown command ${subcmd}"
        exit 1
    ;;
esac
