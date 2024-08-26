with
    stg_pagila__customer as (
        select customer_id, store_id, address_id, create_date,
        from {{ ref('stg_pagila__customer') }}
    ),
    stg_pagila__address as (
        select address_id, country, city, district, postal_code
        from {{ ref('stg_pagila__address') }}
    ),
    dim_store_key as (select store_key, store_id from {{ ref('dim_store') }}),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['cust.customer_id', 'store.store_key']) }}
            as customer_key,
            store.store_key,
            cust.customer_id,
            cust.create_date,
            case
                when addr.country = '' then 'N/A' else COALESCE(addr.country, 'N/A')
            end as country,
            case
                when addr.city = '' then 'N/A' else COALESCE(addr.city, 'N/A')
            end as city,
            case
                when addr.district = '' then 'N/A' else COALESCE(addr.district, 'N/A')
            end as district,
            case
                when addr.postal_code = ''
                then 'N/A'
                else COALESCE(addr.postal_code, 'N/A')
            end as postal_code,
            now() as __etl_processed_at
        from stg_pagila__customer as cust
        inner join stg_pagila__address as addr on cust.address_id = addr.address_id
        inner join dim_store as store on cust.store_id = store.store_id
    )
select *
from final
