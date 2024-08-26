with
    src_pagila__category as (
        select {{ dbt_utils.star(source("pagila", "category")) }}
        from {{ source("pagila", "category") }}
    ),

    final as (
        select category_id, name, last_update, _dlt_load_id, _dlt_id
        from src_pagila__category
    )

select *
from final
