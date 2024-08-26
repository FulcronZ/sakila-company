with
    src_pagila__actor as (
        select {{ dbt_utils.star(source("pagila", "actor")) }}
        from {{ source("pagila", "actor") }}
    ),
    final as (
        select actor_id, first_name, last_name, last_update, _dlt_load_id, _dlt_id
        from src_pagila__actor
    )

select *
from final
