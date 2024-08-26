with
    stg_pagila__store as (
        select store_id, address_id from {{ ref("stg_pagila__store") }}
    ),
    stg_pagila__address as (
        select address_id, country, city, district, postal_code
        from {{ ref("stg_pagila__address") }}
    ),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['store.store_id']) }} as store_key,
            store.store_id,
            addr.country,
            addr.city,
            addr.district,
            addr.postal_code,
            now() as __etl_processed_at
        from stg_pagila__store as store
        inner join stg_pagila__address as addr on store.address_id = addr.address_id
    )

select *
from final
