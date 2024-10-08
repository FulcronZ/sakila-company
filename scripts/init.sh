#/usr/bin/env bash

PAGILA_TAG="pagila-v3.1.0"
echo -n Downloading pagila database.
mkdir -p compose/app-db/docker-entrypoint-initdb.d/
for file_name in pagila-schema.sql pagila-data.sql LICENSE.txt
do
    curl \
        -s -L -o compose/app-db/docker-entrypoint-initdb.d/$file_name \
        https://raw.githubusercontent.com/devrimgunduz/pagila/$PAGILA_TAG/$file_name
done
echo ..done

echo -n "Provide app-db password: "
read -s APP_DB_PASSWORD
echo
mkdir -p compose/app-db/secrets/
echo $APP_DB_PASSWORD > compose/app-db/secrets/db_password.txt

echo -n "Provide analytics-dwh password: "
read -s ANALYTICS_DWH_PASSWORD
echo

echo -n Generating compose/dagster/secrets/dbt_profiles.yml .
mkdir -p compose/dagster/secrets/
cat > compose/dagster/secrets/dbt_profiles.yml <<EOF
sakila_dwh:
  target: default
  outputs:
    default:
      type: clickhouse
      schema: analytics
      user: admin
      password: "$ANALYTICS_DWH_PASSWORD"
      #optional fields
      driver: native
      port: 9000
      host: analytics-dwh
      retries: 1
      verify: False
      secure: False
      connect_timeout: 10
      send_receive_timeout: 300
      sync_request_timeout: 5
      # compression: False
      compress_block_size: 1048576
      # database_engine: <db_engine>
      check_exchange: True
      # use_lw_deletes: False
      # custom_settings: <empty>
EOF
echo ..done

echo -n Generating compose/dagster/secrets/dlt_secrets.toml .
mkdir -p compose/dagster/secrets/
cat > compose/dagster/secrets/dlt_secrets.toml <<EOF
[sources.sql_database.pagila.credentials]
drivername = "postgresql+psycopg2"
host = "app-db"
port = "5432"
database = "pagila"
username = "postgres"
password = "$APP_DB_PASSWORD"

[analytics_dwh__pagila.destination.clickhouse.credentials]
host = "analytics-dwh"
database = "raw_pagila"
username = "admin"
password = "$ANALYTICS_DWH_PASSWORD"
port = 9000
http_port = 8123
secure = 0
EOF
echo ..done

echo -n Downloading metabase clickhouse driver.
mkdir -p compose/metabase/plugins/
METABASE_CLICKHOUSE_DRIVER_TAG=1.50.5
curl \
    -s -L -o compose/metabase/plugins/LICENSE \
    https://raw.githubusercontent.com/ClickHouse/metabase-clickhouse-driver/$METABASE_CLICKHOUSE_DRIVER_TAG/LICENSE
curl \
    -s -L -o compose/metabase/plugins/clickhouse.jar \
    https://github.com/ClickHouse/metabase-clickhouse-driver/releases/download/$METABASE_CLICKHOUSE_DRIVER_TAG/clickhouse.metabase-driver.jar
echo ..done

echo -n "Provide dagster-db password: "
read -s DAGSTER_DB_PASSWORD
echo
mkdir -p compose/dagster-db/secrets/
echo $APP_DB_PASSWORD > compose/dagster-db/secrets/db_password.txt

echo -n "Provide metabase-db password: "
read -s METABASE_DB_PASSWORD
echo
mkdir -p compose/metabase-db/secrets/
echo $METABASE_DB_PASSWORD > compose/metabase-db/secrets/db_password.txt

echo -n Generating compose/.env .
cat > compose/.env <<EOF
ANALYTICS_DWH_USER=admin
ANALYTICS_DWH_PASSWORD=$ANALYTICS_DWH_PASSWORD

DAGSTER_DB_PASSWORD=$DAGSTER_DB_PASSWORD
DAGSTER_APP_DB_USERNAME=postgres
DAGSTER_APP_DB_PASSWORD=$APP_DB_PASSWORD
DAGSTER_CLICKHOUSE_USERNAME=admin
DAGSTER_CLICKHOUSE_PASSWORD=$ANALYTICS_DWH_PASSWORD
EOF
echo ..done

echo -n Building docker images.
docker compose --env-file compose/.env build
echo ..done

echo "Run the following command to initialize database"
echo "Then press Ctrl+c when initialization finishes"
echo "docker compose --env-file compose/.env up app-db analytics-dwh dagster-db metabase-db"

echo "Run the following to start the project after finishing steps above"
echo "docker compose --env-file compose/.env up"
