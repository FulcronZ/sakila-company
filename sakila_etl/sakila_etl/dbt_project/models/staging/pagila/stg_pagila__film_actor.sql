with
    src_pagila__film_actor as (
        select {{ dbt_utils.star(source("pagila", "film_actor")) }}
        from {{ source("pagila", "film_actor") }}
    ),

    final as (
        select actor_id, film_id, last_update, _dlt_load_id, _dlt_id
        from src_pagila__film_actor
    )

select *
from final
