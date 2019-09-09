### in conf/spark-env.sh ###

# If $HADOOP_HOME is defined and points to the hadoop homedir installation
export SPARK_DIST_CLASSPATH=$SPARK_HOME/jars/*:$(${HADOOP_HOME}/bin/hadoop classpath)
