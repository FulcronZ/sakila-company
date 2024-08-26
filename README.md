# Sakila Company

Sakila Company is a reference project for delivering an analytics platform
built solely from open source software for [Sakila][sakila-history],
a fictional DVD rental company.

## Getting Started

```sh
$ ./scripts/init.sh
$ docker compose --env-file compose/.env up
```

The initialization script downloads required files and generates credential
and environment files for every component.

### Ports:

- 3000 - Dagster
- 3100 - Metabase
- 5432 - App Database (Postgresql)
- 18123 - Analytics Data Warehouse (Clickhouse HTTP)
- 19000 - Analytics Data Warehouse (Clickhouse Native)

## Background

The author had been working as a data engineer and the first data person
in a SaaS company in Thailand during 2022-2024. It was gold rush time for
big data management tools and platforms. However, working in a developing
country as Thailand, it didn't have profit margin enough to use commercial
platforms showcased by developed countries. He had to develop and maintain
data pipelines and data quality without the nicety of modern tools, as if
it was in the pre-data science era.

He doesn't want data engineering to be blamed for being "Cost Centric" by
executives anymore. One of effective ways to reduce cost is to host software
by yourself as much as possible, so he came up with the project. Any company
that struggles with its data platform operating cost can use this as a
reference and adapt to fit its budget and team's knowledge level.

## Architecture

This project uses [Pagila][pagila-data], a [Postgresql][postgres] adaptation of
[MySQL Sakila][sakila-data] database, as application data.

The project uses ELT pipeline approach, i.e. try to dump data to analytics
data storage, such as data warehouse and data lake, as much as possible.
The application data is loaded to [Clickhouse][clickhouse] data warehouse
for serving analytics. [Dagster][dagster] stands at the center orchestrating
loading, transforming and testing data. Loading and transforming across data
storages are powered by [dlt][dlt] library. [dbt][dbt] provides modeling,
transforming and testing data in the data warehouse.

Data after normalized into star schema in the data warehouse is served by
[Metabase][metabase] as dashboards and analyses.

All of these components are deployed with a monolithic docker compose file.

## Future Works

It will be migrated to [Kubernetes][k8s] to ease deployment and scaling to
either on-premise servers or cloud providers.

[DataHub][datahub] will be used as a data catalog for teams to look up.

The project will allow adding and modifying application data and will include
more variety of data sources, e.g. web/app analytics tracker and open datasets,
to mimic day-to-day operations and enhance analyses.

[sakila-history]: https://dev.mysql.com/doc/sakila/en/sakila-history.html
[sakila-data]: https://dev.mysql.com/doc/sakila/en/sakila-history.html
[pagila-data]: https://github.com/devrimgunduz/pagila
[postgres]: https://www.postgresql.org/
[clickhouse]: https://clickhouse.com/
[dagster]: https://dagster.io/
[dlt]: https://dlthub.com/
[dbt]: https://www.getdbt.com/
[metabase]: https://www.metabase.com/
[k8s]: https://kubernetes.io/
[datahub]: https://datahubproject.io/
