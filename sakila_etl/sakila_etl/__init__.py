import os

from dagster import Definitions, load_assets_from_modules
from dagster_dbt import DbtCliResource
from dagster_embedded_elt.dlt import DagsterDltResource

# from . import dbt_assets, dlt_assets
from . import dlt_assets, dbt_assets
from .dbt_assets import dbt_project

dbt_profiles_dir = os.getenv("DBT_PROFILES_DIR", None)
dlt_resource = DagsterDltResource()

# all_assets = load_assets_from_modules([dbt_assets, dlt_assets])
all_assets = load_assets_from_modules([dbt_assets, dlt_assets])

resources = {
    "dbt": DbtCliResource(
        project_dir=dbt_project,
        profiles_dir=dbt_profiles_dir,
    ),
    "dlt": dlt_resource,
}

defs = Definitions(
    assets=all_assets,
    resources=resources,
)
