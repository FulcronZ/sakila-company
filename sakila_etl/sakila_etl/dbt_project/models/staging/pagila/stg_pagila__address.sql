with
    base_pagila__country as (
        select {{ dbt_utils.star(ref("base_pagila__country")) }}
        from {{ ref("base_pagila__country") }}
    ),
    base_pagila__city as (
        select {{ dbt_utils.star(ref("base_pagila__city")) }}
        from {{ ref("base_pagila__city") }}
    ),
    base_pagila__address as (
        select {{ dbt_utils.star(ref("base_pagila__address")) }}
        from {{ ref("base_pagila__address") }}
    ),

    address_joined as (
        select
            addr.address_id,
            country.country,
            city.city,
            addr.address,
            addr.address2,
            addr.district,
            addr.postal_code,
            addr.phone,
            case
                when
                    addr.last_update >= country.last_update
                    and addr.last_update >= city.last_update
                then 'address'
                when
                    city.last_update >= country.last_update
                    and city.last_update >= addr.last_update
                then 'city'
                else 'country'
            end as latest_source,
            country.last_update as country_last_update,
            city.last_update as city_last_update,
            addr.last_update as addr_last_update,
            country._dlt_load_id as country__dlt_load_id,
            country._dlt_id as country__dlt_id,
            city._dlt_load_id as city__dlt_load_id,
            city._dlt_id as city__dlt_id,
            addr._dlt_load_id as addr__dlt_load_id,
            addr._dlt_id as addr__dlt_id

        from base_pagila__address as addr
        inner join base_pagila__city as city on addr.city_id = city.city_id
        inner join
            base_pagila__country as country on city.country_id = country.country_id
    ),

    final as (
        select
            address_id,
            country,
            city,
            address,
            address2,
            district,
            postal_code,
            phone,
            case
                when latest_source = 'address'
                then addr_last_update
                when latest_source = 'city'
                then city_last_update
                else country_last_update
            end as last_update,
            case
                when latest_source = 'address'
                then addr__dlt_load_id
                when latest_source = 'city'
                then city__dlt_load_id
                else country__dlt_load_id
            end as _dlt_load_id,
            case
                when latest_source = 'address'
                then addr__dlt_id
                when latest_source = 'city'
                then city__dlt_id
                else country__dlt_id
            end as _dlt_id
        from address_joined
    )

select *
from final
