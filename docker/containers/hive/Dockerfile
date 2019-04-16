ARG HADOOP_VERSION=3.1.1

FROM datalabframework-demos/hadoop:${HADOOP_VERSION}

ARG HADOOP_VERSION
ARG APACHE_DIST=https://apache.org/dist
ARG APACHE_MIRROR=https://dist.apache.org/repos/dist/release

RUN set -eux; \
    apt-get -y update; \
    apt-get install --no-install-recommends -y libxml2-utils; \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

ENV HIVE_HOME=/opt/hive

RUN set -eux; \
    cd /tmp;  \
    wget -qO - "${APACHE_DIST}/hive/KEYS" | gpg --batch --import -; \
    wget       "${APACHE_MIRROR}/hive/hive-${HADOOP_VERSION}/apache-hive-${HADOOP_VERSION}-bin.tar.gz" --progress=bar:force; \
    wget -qO - "${APACHE_DIST}/hive/hive-${HADOOP_VERSION}/apache-hive-${HADOOP_VERSION}-bin.tar.gz.asc" | gpg --batch --verify - "apache-hive-${HADOOP_VERSION}-bin.tar.gz"; \
    tar -xzf "apache-hive-${HADOOP_VERSION}-bin.tar.gz" -C /opt --owner root --group root --no-same-owner; \
    rm  -rf  "apache-hive-${HADOOP_VERSION}-bin.tar.gz" "$HOME/.gnupg"; \
    mv  "/opt/apache-hive-${HADOOP_VERSION}-bin" "${HIVE_HOME}"

ENV  PATH="${HIVE_HOME}/bin:${PATH}"
COPY scripts/ /usr/local/bin/
