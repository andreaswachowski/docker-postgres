#!/bin/bash -e

psql -v ON_ERROR_STOP=1 --username postgres template1 <<-EOSQL
CREATE EXTENSION hstore;
CREATE EXTENSION pg_trgm;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE EXTENSION hstore;
CREATE EXTENSION pg_trgm;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA dblink;
    CREATE EXTENSION dblink SCHEMA dblink;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA jobmon;
    CREATE EXTENSION pg_jobmon SCHEMA jobmon;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE SCHEMA partman;
    CREATE EXTENSION pg_partman SCHEMA partman;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE EXTENSION pldbgapi;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    GRANT USAGE ON SCHEMA jobmon TO $POSTGRES_USER;
    GRANT USAGE ON SCHEMA dblink to $POSTGRES_USER;
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA jobmon TO $POSTGRES_USER;
    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA jobmon TO $POSTGRES_USER;
    GRANT ALL ON ALL SEQUENCES IN SCHEMA jobmon TO $POSTGRES_USER;
EOSQL

echo "shared_preload_libraries = 'pg_partman_bgw,plugin_debugger'" >> $PGDATA/postgresql.conf
