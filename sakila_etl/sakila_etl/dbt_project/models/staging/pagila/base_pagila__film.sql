with
    src_pagila__film as (
        select {{ dbt_utils.star(source("pagila", "film")) }}
        from {{ source("pagila", "film") }}
    ),

    final as (
        select
            film_id,
            title,
            description,
            language_id,
            original_language_id,
            rental_duration,
            rental_rate,
            length,
            replacement_cost,
            rating,
            last_update,
            release_year,
            fulltext,
            _dlt_load_id,
            _dlt_id
        from src_pagila__film
    )

select *
from final
