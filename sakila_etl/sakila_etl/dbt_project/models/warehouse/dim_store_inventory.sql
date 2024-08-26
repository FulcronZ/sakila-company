with
    stg_pagila__inventory as (
        select inventory_id, film_id, store_id, from {{ ref('stg_pagila__inventory') }}
    ),
    dim_store as (
        select store.store_key, store.store_id from {{ ref('dim_store') }} as store
    ),
    dim_film as (select film.film_key, film.film_id from {{ ref('dim_film') }} as film),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['inv.inventory_id', 'store.store_key', 'film.film_key']) }}
            as inventory_key,
            store.store_key,
            film.film_key,
            inv.inventory_id,
            now() as __etl_processed_at
        from stg_pagila__inventory as inv
        inner join dim_store as store on inv.store_id = store.store_id
        inner join dim_film as film on inv.film_id = film.film_id
    )
select *
from final
