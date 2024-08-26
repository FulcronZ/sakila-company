with
    src_pagila__store as (
        select {{ dbt_utils.star(source("pagila", "store")) }}
        from {{ source("pagila", "store") }}
    ),

    final as (
        select
            store_id, manager_staff_id, address_id, last_update, _dlt_load_id, _dlt_id
        from src_pagila__store
    )

select *
from final
