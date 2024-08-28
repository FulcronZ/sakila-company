import os
from typing import Dict
import dlt
from dlt.common.configuration.providers import ProjectDocProvider, SECRETS_TOML

from .connectors.sql_database import sql_database
from .utils import TableConfig


# Add extra secret lookup file if provided
DLT_SECRETS_DIR = os.getenv("DLT_SECRETS_DIR")
if DLT_SECRETS_DIR:
    provider = ProjectDocProvider(
        name="custom",
        supports_secrets=True,
        project_dir=DLT_SECRETS_DIR,
        file_name=SECRETS_TOML,
        add_global_config=False,
    )
    dlt.secrets.register_provider(provider)

TABLE_CONFIGS: Dict[str, TableConfig] = {
    "actor": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "actor_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "address": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "address_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "category": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "category_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "city": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "city_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "country": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "country_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "customer": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "customer_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "film": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "film_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "film_actor": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": ["film_id", "actor_id"],
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "film_category": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": ["film_id", "category_id"],
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "inventory": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "inventory_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "language": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "language_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "payment": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "payment_id",
            "incremental": dlt.sources.incremental("payment_date"),
        }
    },
    "rental": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "rental_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "staff": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "staff_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
    "store": {
        "hints": {
            "write_disposition": {"disposition": "merge", "strategy": "delete-insert"},
            "primary_key": "store_id",
            "incremental": dlt.sources.incremental("last_update"),
        }
    },
}

pagila = dlt.source(sql_database, name="pagila")()
pagila = pagila.with_resources(*tuple(TABLE_CONFIGS.keys()))

# Configure sync mode for every table
for table, config in TABLE_CONFIGS.items():
    pagila.resources[table].apply_hints(**config["hints"])
