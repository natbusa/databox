#!/bin/bash
set -e

cat >/tmp/spark_session.py <<EOL
from pyspark.sql import SparkSession, SQLContext
spark = SparkSession.builder.getOrCreate()
spark.version
EOL

SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${SPARK_HOME}/jars/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/common/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/common/lib/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/hdfs/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/hdfs/lib/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/mapreduce/lib/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/mapreduce/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/yarn/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/yarn/lib/*
SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}:${HADOOP_HOME}/share/hadoop/tools/lib/*

#pre-cached jars and packages
export SPARK_DIST_CLASSPATH=${SPARK_DIST_CLASSPATH}

# S3A aws protocol (AWS and MINIO)
HADOOP_VERSION=$($HADOOP_HOME/bin/hadoop version | head -n 1 | awk '{print $2}')
${SPARK_HOME}/bin/spark-submit --packages "org.apache.hadoop:hadoop-aws:${HADOOP_VERSION}" /tmp/spark_session.py

#jdbc connectors
${SPARK_HOME}/bin/spark-submit --packages "org.xerial:sqlite-jdbc:3.25.2" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "mysql:mysql-connector-java:8.0.12" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "org.postgresql:postgresql:42.2.5" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "com.microsoft.sqlserver:mssql-jdbc:6.4.0.jre8" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "ru.yandex.clickhouse:clickhouse-jdbc:0.1.54" /tmp/spark_session.py

# preloading oracle 12.2 and oracle 11.1
${SPARK_HOME}/bin/spark-submit --packages "com.oracle.jdbc:ojdbc8:12.2.0.1" \
                               --repositories http://maven.icm.edu.pl/artifactory/repo/,https://maven.xwiki.org/externals \
                               /tmp/spark_session.py

${SPARK_HOME}/bin/spark-submit --packages "com.oracle.jdbc:ojdbc6:11.2.0.4" \
                              --repositories http://maven.icm.edu.pl/artifactory/repo/,https://maven.xwiki.org/externals \
                              /tmp/spark_session.py
