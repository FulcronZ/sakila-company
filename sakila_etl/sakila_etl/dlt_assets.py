from typing import Iterable, List

from dagster import AssetExecutionContext, AssetKey, Config
from dagster_embedded_elt.dlt import (
    DagsterDltResource,
    dlt_assets,
    DagsterDltTranslator,
)
from dlt import pipeline
from dlt.extract.resource import DltResource

from .dlt_project.sources import pagila


class CustomDltConfig(Config):
    full_refresh: bool = False


class CustomDagsterDltTranslator(DagsterDltTranslator):
    def __init__(self, asset_prefix: List[str], deps_prefix: List[str]):
        self.asset_prefix = asset_prefix
        self.deps_prefix = deps_prefix

    def get_asset_key(self, resource: DltResource) -> AssetKey:
        if self.asset_prefix:
            return AssetKey(resource.name).with_prefix(self.asset_prefix)
        return super().get_asset_key(resource)

    def get_deps_asset_keys(self, resource: DltResource) -> Iterable[AssetKey]:
        asset_keys = super().get_deps_asset_keys(resource)
        asset_keys = list(map(lambda k: k.with_prefix(self.deps_prefix), asset_keys))
        return asset_keys


@dlt_assets(
    dlt_source=pagila,
    dlt_pipeline=pipeline(
        pipeline_name="analytics_dwh__pagila",  # Destination name for credential look up
        dataset_name="raw_pagila",  # Table prefix
        destination="clickhouse",  # Destination driver
    ),
    dagster_dlt_translator=CustomDagsterDltTranslator(
        asset_prefix=["analytics_dwh", "raw", "pagila"],
        deps_prefix=["apps_db"],
    ),
    name="raw_pagila",
)
def analytics_dwh_pagila_assets(
    context: AssetExecutionContext, dlt: DagsterDltResource, config: CustomDltConfig
):
    if config.full_refresh:
        write_disposition = "replace"
    else:
        write_disposition = None

    yield from dlt.run(context=context, write_disposition=write_disposition)
