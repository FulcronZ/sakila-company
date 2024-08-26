with
    src_pagila__rental as (
        select {{ dbt_utils.star(source("pagila", "rental")) }}
        from {{ source("pagila", "rental") }}
    ),

    final as (
        select
            rental_id,
            rental_date,
            inventory_id,
            customer_id,
            return_date,
            staff_id,
            last_update,
            _dlt_load_id,
            _dlt_id
        from src_pagila__rental
    )

select *
from final
