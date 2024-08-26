with
    stg_pagila__rental as (
        select rental_id, rental_date, inventory_id, customer_id, return_date, staff_id
        from {{ ref('stg_pagila__rental') }}
    ),
    stg_pagila__payment as (
        select payment_id, customer_id, staff_id, rental_id, amount, payment_date
        from {{ ref('stg_pagila__payment') }}
        where rental_id is not NULL
    ),
    dim_store_inventory as (
        select inventory_key, film_key, store_key, inventory_id
        from {{ ref('dim_store_inventory') }}
    ),
    dim_customer as (select customer_key, customer_id from {{ ref('dim_customer') }}),
    dim_staff as (select staff_key, staff_id from {{ ref('dim_staff') }}),
    final as (
        select
            {{
                dbt_utils.generate_surrogate_key([
                    'rent.rental_id',
                    'inv.inventory_key',
                    'inv.film_key',
                    'inv.store_key',
                    'rcust.customer_key',
                    'rstaff.staff_key',
                    'pcust.customer_key',
                    'pstaff.staff_key'
                ])
            }} as fact_key,
            toUInt32(formatDateTime(rent.rental_date, '%Y%m%d')) as rent_date_key,
            toUInt32(formatDateTime(rent.return_date, '%Y%m%d')) as return_date_key,
            toUInt32(formatDateTime(pay.payment_date, '%Y%m%d')) as pay_date_key,
            inv.inventory_key as inventory_key,
            inv.film_key as film_key,
            inv.store_key as rent_store_key,
            rcust.customer_key as rent_customer_key,
            rstaff.staff_key as rent_staff_key,
            pcust.customer_key as pay_customer_key,
            pstaff.staff_key as pay_staff_key,
            rent.rental_id as rental_id,
            rent.rental_date as rent_ts,
            rent.return_date as return_ts,
            pay.payment_date as pay_ts,
            pay.amount as pay_amount,
            now() as __etl_processed_at
        from stg_pagila__rental as rent
        inner join stg_pagila__payment as pay on rent.rental_id = pay.rental_id
        inner join dim_store_inventory as inv on rent.inventory_id = inv.inventory_id
        inner join dim_customer as rcust on rent.customer_id = rcust.customer_id
        inner join dim_staff as rstaff on rent.staff_id = rstaff.staff_id
        inner join dim_customer as pcust on pay.customer_id = pcust.customer_id
        inner join dim_staff as pstaff on pay.staff_id = pstaff.staff_id
    )
select *
from final
