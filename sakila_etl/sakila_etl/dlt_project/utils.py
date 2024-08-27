from typing import TypedDict
from dlt.common.schema.typing import TWriteDispositionConfig
from dlt.extract.incremental import Incremental


class TableHint(TypedDict, total=False):
    write_disposition: TWriteDispositionConfig
    primary_key: str
    incremental: Incremental


class TableConfig(TypedDict):
    hints: TableHint
