ARG POSTGRESQL_VERSION="17"
FROM bitnami/postgresql:$POSTGRESQL_VERSION

ARG PARTMAN_VERSION="v5.2.2"
ARG PARTMAN_CHECKSUM="a63e02b0e515b2aeb0fd88a2bcd70f60625d6b09851aaa4d54e7b791a6a661aa14fd8d25fe5893297447e2ab2c2f81437017adfb0bad60629e1e94a15cf4976e"

USER root
RUN install_packages wget gcc make build-essential
RUN cd /tmp \
    # Fetch partman & check its SHA512 checksum for integrity
    && wget "https://github.com/pgpartman/pg_partman/archive/refs/tags/${PARTMAN_VERSION}.tar.gz" \
    && echo "${PARTMAN_CHECKSUM} ${PARTMAN_VERSION}.tar.gz" | sha512sum --check \
    # Set compiler options
    && export C_INCLUDE_PATH=/opt/bitnami/postgresql/include/:/opt/bitnami/common/include/ \
    && export LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    && export LD_LIBRARY_PATH=/opt/bitnami/postgresql/lib/:/opt/bitnami/common/lib/ \
    # Extract partman
    && tar zxf ${PARTMAN_VERSION}.tar.gz && cd pg_partman-${PARTMAN_VERSION#v}\
    # make
    && make \
    && make install \
    # Remove compressed partman
    && cd .. && rm -r pg_partman-${PARTMAN_VERSION#v} ${PARTMAN_VERSION}.tar.gz

LABEL org.opencontainers.image.source="https://github.com/MagicA550/postgres-partman"
LABEL dev.magicanthony.partman-version=$PARTMAN_VERSION
LABEL dev.magicanthony.postgres-version=$POSTGRESQL_VERSION

USER 1001
