with
    src_pagila__city as (
        select {{ dbt_utils.star(source("pagila", "city")) }}
        from {{ source("pagila", "city") }}
    ),

    final as (
        select city_id, city, country_id, last_update, _dlt_load_id, _dlt_id
        from src_pagila__city
    )

select *
from final
