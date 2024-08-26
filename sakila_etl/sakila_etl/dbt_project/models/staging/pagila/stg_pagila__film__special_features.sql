with
    src_pagila__film__special_features as (
        select {{ dbt_utils.star(source("pagila", "film__special_features")) }}
        from {{ source("pagila", "film__special_features") }}
    ),

    final as (
        select value, _dlt_id, _dlt_parent_id, _dlt_list_idx
        from src_pagila__film__special_features
    )

select *
from final
