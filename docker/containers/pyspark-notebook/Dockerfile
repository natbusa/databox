FROM jupyter/scipy-notebook

# Hadoop and spark versions
ARG HADOOP_VERSION=3.1.1
ARG SPARK_VERSION=2.4.0

# apache mirrors and dist
ARG APACHE_DIST=https://apache.org/dist
ARG APACHE_MIRROR=https://dist.apache.org/repos/dist/release

USER root
SHELL [ "/bin/bash", "-c" ]

COPY scripts/preload_spark_packages.sh /tmp/preload_spark_packages.sh
COPY scripts/download_jars.sh /tmp/download_jars.sh

# update the system
RUN apt-get -y update;

# install system utils
RUN apt-get install --no-install-recommends -y vim gnupg curl tzdata;

# install sasl and ssh-client
RUN apt-get install --no-install-recommends -y \
  openssh-client libsasl2-modules libsasl2-dev;

# install java
RUN apt-get install --no-install-recommends -y \
  ca-certificates-java openjdk-8-jre-headless;

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# install monitoring utils
RUN apt-get install --no-install-recommends -y \
  iproute2 net-tools telnet dnsutils iputils-* htop iftop;

# clean apt cache
RUN set -eux; apt-get clean; rm -rf /var/lib/apt/lists/*;

ENV HADOOP_HOME=/opt/hadoop
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native
ENV PATH="${HADOOP_HOME}/bin:${PATH}"

RUN set -eux; \
    cd /tmp;  \
    wget -qO - "${APACHE_DIST}/hadoop/common/KEYS" | gpg --import -; \
    wget       "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" --progress=bar:force; \
    wget -qO - "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" | gpg --verify - "hadoop-${HADOOP_VERSION}.tar.gz"; \
    tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" -C /opt --owner root --group root --no-same-owner; \
    rm  -rf  "hadoop-${HADOOP_VERSION}.tar.gz" "$HOME/.gnupg"; \
    ln  -s   "/opt/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}"

ENV SPARK_HOME=/opt/spark
ENV PYTHONPATH="${SPARK_HOME}/python:${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip"
ENV PATH="${SPARK_HOME}/bin:${PATH}"

RUN set -eux; \
    cd /tmp;  \
    wget -qO - "${APACHE_DIST}/spark/KEYS" | gpg --import -; \
    wget       "${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz" --progress=bar:force; \
    wget -qO - "${APACHE_DIST}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz.asc" | gpg --verify - "spark-${SPARK_VERSION}-bin-without-hadoop.tgz"; \
    tar -xzf "spark-${SPARK_VERSION}-bin-without-hadoop.tgz" -C /opt --owner root --group root --no-same-owner; \
    rm  -rf  "spark-${SPARK_VERSION}-bin-without-hadoop.tgz" "$HOME/.gnupg"; \
    ln  -s   "/opt/spark-${SPARK_VERSION}-bin-without-hadoop" ${SPARK_HOME};

####################
# RUN mkdir -p /usr/local/share/jupyter /usr/local/etc/jupyter; \
#    chown $NB_UID:$NB_GID /usr/local/share/jupyter /usr/local/etc/jupyter;

# add password for $(NB_USER)
# RUN set -eux; usermod -aG sudo ${NB_USER}; echo "${NB_USER}:juno" | chpasswd
####################

# Preload aws s3a support and jdbc drivers

#s3a (aws and minio)
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars org.apache.hadoop:hadoop-aws:3.1.1
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars com.amazonaws:aws-java-sdk-bundle:1.11.271

#mysql
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars com.google.protobuf:protobuf-java:2.6.0
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars mysql:mysql-connector-java:8.0.12

#mssql
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars com.microsoft.sqlserver:mssql-jdbc:6.4.0.jre8

#postgresql
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars org.postgresql:postgresql:42.2.5

#sqlite
RUN /tmp/download_jars.sh --dir=${SPARK_HOME}/jars org.xerial:sqlite-jdbc:3.25.2

# oracle
RUN wget -P ${SPARK_HOME}/jars http://www.datanucleus.org/downloads/maven2/oracle/ojdbc6/11.2.0.3/ojdbc6-11.2.0.3.jar

USER $NB_UID

## jupyter, arrow, and jupyterlab
#RUN set -eux; \
#    conda install nbdime \
#    conda install -y -c conda-forge jupyter_contrib_nbextensions; \
#    conda install -y -c conda-forge boost pyarrow; \
#    jupyter contrib nbextension install; \
#    jupyter labextension install nbdime-jupyterlab; \
#    nbdime config-git --enable --global;
#
## other bespoken python packages
#RUN set -eux; \
#    conda install -y python-dotenv
#
## cleanup
#RUN set -eux; \
#    conda clean -tipsy; \
#    npm cache clean --force; \
#    rm -rf $CONDA_DIR/share/jupyter/lab/staging; \
#    rm -rf /home/$NB_USER/.cache/yarn; \
#    rm -rf /home/$NB_USER/.node-gyp; \
#    fix-permissions $CONDA_DIR; \
#    fix-permissions /home/$NB_USER
RUN echo $SPARK_DIST_CLASSPATH
