with
    src_pagila__staff as (
        select {{ dbt_utils.star(source("pagila", "staff")) }}
        from {{ source("pagila", "staff") }}
    ),

    final as (
        select
            staff_id,
            first_name,
            last_name,
            address_id,
            email,
            store_id,
            active,
            username,
            last_update,
            _dlt_load_id,
            _dlt_id
        from src_pagila__staff
    )

select *
from final
