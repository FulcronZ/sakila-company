with
    src_pagila__country as (
        select {{ dbt_utils.star(source("pagila", "country")) }}
        from {{ source("pagila", "country") }}
    ),

    final as (
        select country_id, country, last_update, _dlt_load_id, _dlt_id
        from src_pagila__country
    )

select *
from final
