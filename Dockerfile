FROM postgres:16

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        postgresql-server-dev-16 \
        git \
    && rm -rf /var/lib/apt/lists/*

RUN GIT_SSL_NO_VERIFY=1 git clone https://github.com/pgbigm/pg_bigm.git \
    && cd pg_bigm \
    && make USE_PGXS=1 \
    && make USE_PGXS=1 install \
    && cd .. \
    && rm -rf pg_bigm

RUN echo "psql -v ON_ERROR_STOP=1 --username '$$POSTGRES_USER' --dbname '$$POSTGRES_DB' -c 'CREATE EXTENSION pg_bigm;'" > /docker-entrypoint-initdb.d/init-pg-bigm.sh \
    && chmod +x /docker-entrypoint-initdb.d/init-pg-bigm.sh
