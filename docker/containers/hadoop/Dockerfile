FROM openjdk:8-jre-stretch

ARG HADOOP_VERSION=3.1.1
ARG APACHE_DIST=https://apache.org/dist
ARG APACHE_MIRROR=https://dist.apache.org/repos/dist/release

ENV HADOOP_HOME=/opt/hadoop

RUN set -eux; \
    cd /tmp;  \
    wget -qO - "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    wget       "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" --progress=bar:force; \
    wget -qO - "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz"; \
    tar -xzf "hadoop-${HADOOP_VERSION}.tar.gz" -C /opt --owner root --group root --no-same-owner; \
    rm  -rf  "hadoop-${HADOOP_VERSION}.tar.gz" "$HOME/.gnupg"; \
    mv  "/opt/hadoop-${HADOOP_VERSION}" "${HADOOP_HOME}"

ENV  PATH="${HADOOP_HOME}/bin:${PATH}"
COPY scripts/ /usr/local/bin/
