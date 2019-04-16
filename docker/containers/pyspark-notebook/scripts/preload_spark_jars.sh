#!/bin/bash
set -e

# Preload aws s3a support and jdbc drivers

#s3a (aws and minio)
./download_jars.sh --dir=${SPARK_HOME}/jars org.apache.hadoop:hadoop-aws:3.1.1
./download_jars.sh --dir=${SPARK_HOME}/jars com.amazonaws:aws-java-sdk-bundle:1.11.271

#mysql
./download_jars.sh --dir=${SPARK_HOME}/jars com.google.protobuf:protobuf-java:2.6.0
./download_jars.sh --dir=${SPARK_HOME}/jars mysql:mysql-connector-java:8.0.12

#mssql
./download_jars.sh --dir=${SPARK_HOME}/jars com.microsoft.sqlserver:mssql-jdbc:6.4.0.jre8

#postgresql
./download_jars.sh --dir=${SPARK_HOME}/jars org.postgresql:postgresql:42.2.5

#sqlite
./download_jars.sh --dir=${SPARK_HOME}/jars org.xerial:sqlite-jdbc:3.25.2

# oracle
wget -P ${SPARK_HOME}/jars http://www.datanucleus.org/downloads/maven2/oracle/ojdbc6/11.2.0.3/ojdbc6-11.2.0.3.jar
