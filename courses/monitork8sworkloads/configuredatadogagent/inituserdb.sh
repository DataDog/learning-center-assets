#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER datadog;
    GRANT pg_monitor to datadog;
    GRANT SELECT ON pg_stat_database to datadog;

EOSQL