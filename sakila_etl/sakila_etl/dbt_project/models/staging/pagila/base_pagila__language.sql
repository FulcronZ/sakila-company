with
    src_pagila__language as (
        select {{ dbt_utils.star(source("pagila", "language")) }}
        from {{ source("pagila", "language") }}
    ),

    final as (
        select language_id, name, last_update, _dlt_load_id, _dlt_id
        from src_pagila__language
    )

select *
from final
