with
    base_pagila__film as (
        select {{ dbt_utils.star(ref("base_pagila__film")) }}
        from {{ ref("base_pagila__film") }}
    ),

    base_pagila__language as (
        select {{ dbt_utils.star(ref("base_pagila__language")) }}
        from {{ ref("base_pagila__language") }}
    ),

    final as (
        select
            film.film_id,
            film.title,
            film.description,
            lang1.name as language,
            lang2.name as original_language,
            film.rental_duration,
            film.rental_rate,
            film.length,
            film.replacement_cost,
            film.rating,
            film.last_update,
            film.release_year,
            film.fulltext,
            film._dlt_load_id as _dlt_load_id,
            film._dlt_id as _dlt_id
        from base_pagila__film as film
        inner join
            base_pagila__language as lang1 on film.language_id = lang1.language_id
        left join
            base_pagila__language as lang2
            on film.original_language_id = lang2.language_id
    )

select *
from final
