with
    stg_pagila__staff as (
        select staff_id, store_id, address_id from {{ ref("stg_pagila__staff") }}
    ),
    stg_pagila__store as (
        select store_id, manager_staff_id from {{ ref("stg_pagila__store") }}
    ),
    stg_pagila__address as (
        select address_id, country, city, district, postal_code
        from {{ ref("stg_pagila__address") }}
    ),
    dim_store as (select store_key, store_id from {{ ref("dim_store") }}),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['staff.staff_id', 'dstore.store_key']) }}
            as staff_key,
            dstore.store_key,
            staff.staff_id,
            staff_id = store.manager_staff_id as is_manager,
            addr.country,
            addr.city,
            addr.district,
            addr.postal_code,
            now() as __etl_processed_at
        from stg_pagila__staff as staff
        inner join stg_pagila__store as store on staff.store_id = store.store_id
        inner join dim_store as dstore on staff.store_id = dstore.store_id
        inner join stg_pagila__address as addr on staff.address_id = addr.address_id
    )

select *
from final
