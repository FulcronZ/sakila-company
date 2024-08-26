with
    src_pagila__film_category as (
        select {{ dbt_utils.star(source("pagila", "film_category")) }}
        from {{ source("pagila", "film_category") }}
    ),
    base_pagila__category as (
        select {{ dbt_utils.star(ref('base_pagila__category')) }}
        from {{ ref('base_pagila__category') }}
    ),

    final as (
        select
            film.film_id,
            cat.name as category,
            film.last_update,
            film._dlt_load_id,
            film._dlt_id
        from src_pagila__film_category as film
        inner join base_pagila__category as cat on film.category_id = cat.category_id
    )

select *
from final
