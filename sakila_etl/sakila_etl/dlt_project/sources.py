import dlt

from .connectors.sql_database import sql_database


pagila = dlt.source(sql_database, name="pagila")()

# Configure sync mode for every table
pagila.resources["actor"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="actor_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["address"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="address_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["category"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="category_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["city"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="city_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["country"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="country_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["customer"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="customer_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["film"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="film_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["film_actor"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key=["film_id", "actor_id"],
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["film_category"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key=["film_id", "category_id"],
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["inventory"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="inventory_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["language"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="language_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["payment"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="payment_id",
    incremental=dlt.sources.incremental("payment_date"),
)
pagila.resources["rental"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="rental_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["staff"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="staff_id",
    incremental=dlt.sources.incremental("last_update"),
)
pagila.resources["store"].apply_hints(
    write_disposition={"disposition": "merge", "strategy": "delete-insert"},
    primary_key="store_id",
    incremental=dlt.sources.incremental("last_update"),
)
