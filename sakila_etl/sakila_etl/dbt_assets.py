from pathlib import Path
from typing import Any, Mapping

from dagster import AssetExecutionContext, AssetKey
from dagster_dbt import (
    DagsterDbtTranslator,
    dbt_assets,
    DbtCliResource,
    DbtProject,
)

# TODO: Compile dbt project during CD
dbt_project = DbtProject(project_dir=Path(__file__).parent / "dbt_project")
dbt_project.preparer.prepare(dbt_project)


class CustomDagsterDbtTranslator(DagsterDbtTranslator):
    MODEL_STAGE_PREFIXES = {
        "base_": "staging",
        "stg_": "staging",
        "int_": "intermediate",
        "fct_": "warehouse",
        "dim_": "warehouse",
        "brd_": "warehouse",
    }

    DAGSTER_RAW_SCHEMAS = ["pagila"]

    def get_asset_key(
        self,
        dbt_resource_props: Mapping[str, Any],
    ) -> AssetKey:
        if dbt_resource_props["resource_type"] == "model":
            asset_key = super().get_asset_key(dbt_resource_props)
            model_name: str = dbt_resource_props["name"]

            for prefix, stage in self.MODEL_STAGE_PREFIXES.items():
                if model_name.startswith(prefix):
                    name_parts = model_name.removeprefix(prefix).split("__")
                    asset_prefix = name_parts[:-1]
                    return AssetKey(model_name).with_prefix(
                        ["analytics_dwh", stage, *asset_prefix]
                    )

            asset_key = super().get_asset_key(dbt_resource_props)
            return asset_key.with_prefix(["analytics_dwh", "dbt_schema"])

        if dbt_resource_props["resource_type"] == "source":
            if dbt_resource_props["schema"] in self.DAGSTER_RAW_SCHEMAS:
                return AssetKey(dbt_resource_props["name"]).with_prefix(
                    ["analytics_dwh", "raw", dbt_resource_props["schema"]]
                )

        asset_key = super().get_asset_key(dbt_resource_props)
        return asset_key.with_prefix(["analytics_dwh", "dbt_source"])


@dbt_assets(
    manifest=dbt_project.manifest_path,
    dagster_dbt_translator=CustomDagsterDbtTranslator(),
)
def dbt_project_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream().fetch_row_counts()
