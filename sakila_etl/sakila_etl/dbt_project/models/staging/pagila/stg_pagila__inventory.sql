with
    src_pagila__inventory as (
        select {{ dbt_utils.star(source("pagila", "inventory")) }}
        from {{ source("pagila", "inventory") }}
    ),

    final as (
        select inventory_id, film_id, store_id, last_update, _dlt_load_id, _dlt_id
        from src_pagila__inventory
    )

select *
from final
