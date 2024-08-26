with
    stg_pagila__actor as (
        select actor_id, first_name, last_name from {{ ref('stg_pagila__actor') }}
    ),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['actor_id']) }} as actor_key,
            actor_id,
            first_name,
            last_name,
            now() as __etl_processed_at
        from stg_pagila__actor
    )
select *
from final
