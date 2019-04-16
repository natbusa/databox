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
${SPARK_HOME}/bin/spark-submit --packages "mysql:mysql-connector-java:8.0.12" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "org.xerial:sqlite-jdbc:3.25.2" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "org.postgresql:postgresql:42.2.5" /tmp/spark_session.py
${SPARK_HOME}/bin/spark-submit --packages "com.microsoft.sqlserver:mssql-jdbc:6.4.0.jre8" /tmp/spark_session.py

# oracle via http://www.datanucleus.org
# wget -P /home/$NB_USER/.ivy2/jars http://www.datanucleus.org/downloads/maven2/oracle/ojdbc6/11.2.0.3/ojdbc6-11.2.0.3.jar
