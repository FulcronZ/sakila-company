with
    src_pagila__customer as (
        select {{ dbt_utils.star(source("pagila", "customer")) }}
        from {{ source("pagila", "customer") }}
    ),

    final as (
        select
            customer_id,
            store_id,
            first_name,
            last_name,
            email,
            address_id,
            activebool,
            create_date,
            last_update,
            active,
            _dlt_load_id,
            _dlt_id
        from src_pagila__customer
    )

select *
from final
