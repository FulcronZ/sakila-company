with
    stg_pagila__payment as (
        select payment_id, customer_id, staff_id, amount, payment_date
        from {{ ref('stg_pagila__payment') }}
        where rental_id is NULL
    ),
    dim_customer as (select customer_key, customer_id from {{ ref('dim_customer') }}),
    dim_staff as (select staff_key, staff_id from {{ ref('dim_staff') }}),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['payment_id', 'cust.customer_key', 'staff.staff_key']) }}
            as fact_key,
            toUInt32(formatDateTime(payment_date, '%Y%m%d')) as date_key,
            cust.customer_key,
            staff.staff_key,
            pay.payment_id as pay_id,
            pay.payment_date as pay_ts,
            pay.amount as pay_amount,
            now() as __etl_processed_at
        from stg_pagila__payment as pay
        inner join dim_customer as cust on pay.customer_id = cust.customer_id
        inner join dim_staff as staff on pay.staff_id = staff.staff_id
    )
select *
from final
