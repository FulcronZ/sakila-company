with
    src_pagila__address as (
        select {{ dbt_utils.star(source("pagila", "address")) }}
        from {{ source("pagila", "address") }}
    ),

    final as (
        select
            address_id,
            address,
            address2,
            district,
            city_id,
            postal_code,
            phone,
            last_update,
            _dlt_load_id,
            _dlt_id
        from src_pagila__address
    )

select *
from final
