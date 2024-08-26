with
    stg_pagila__film_actor as (
        select film_id, actor_id from {{ ref('stg_pagila__film_actor') }}
    ),
    dim_film as (select film.film_key, film.film_id from {{ ref('dim_film') }} as film),
    dim_actor as (select actor_key, actor_id from {{ ref('dim_actor') }}),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['film.film_key', 'actor.actor_key']) }}
            as bridge_key,
            film.film_key,
            actor.actor_key,
            now() as __etl_processed_at
        from stg_pagila__film_actor as brd
        inner join dim_film as film on brd.film_id = film.film_id
        inner join dim_actor as actor on brd.actor_id = actor.actor_id
    )
select *
from final
