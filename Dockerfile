FROM postgres:10

# Based on https://hub.docker.com/r/abakpress/postgres-db/~/dockerfile/

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && apt-get install -yq --no-install-recommends \
    ca-certificates \
    libpq-dev \
    postgresql-server-dev-all \
    postgresql-common \
    wget \
    unzip \
    make \
    build-essential \
    libssl-dev \
    libkrb5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && truncate -s 0 /var/log/*log

RUN wget https://github.com/omniti-labs/pg_jobmon/archive/v1.3.3.zip \
    && unzip v1.3.3.zip \
    && make -C pg_jobmon-1.3.3 \
    && make NO_BGW=1 install -C pg_jobmon-1.3.3

RUN wget https://github.com/keithf4/pg_partman/archive/v3.1.0.zip \
    && unzip v3.1.0.zip \
    && make -C pg_partman-3.1.0 \
    && make install -C pg_partman-3.1.0

ENV PATH /usr/bin:$PATH
