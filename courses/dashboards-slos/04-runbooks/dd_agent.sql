-- Access for the Datadog Agent
create user datadog with password 'datadog';
grant pg_monitor to datadog;
grant SELECT ON pg_stat_database to datadog;