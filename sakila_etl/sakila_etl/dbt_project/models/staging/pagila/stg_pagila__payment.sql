with
    src_pagila__payment as (
        select {{ dbt_utils.star(source("pagila", "payment")) }}
        from {{ source("pagila", "payment") }}
    ),

    final as (
        select
            payment_id,
            customer_id,
            staff_id,
            rental_id,
            amount,
            payment_date,
            _dlt_load_id,
            _dlt_id
        from src_pagila__payment
    )

select *
from final
