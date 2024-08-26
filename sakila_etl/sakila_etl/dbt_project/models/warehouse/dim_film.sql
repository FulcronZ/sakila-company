with
    stg_pagila__film as (
        select
            film_id,
            title,
            description,
            language,
            original_language,
            rental_duration,
            rental_rate,
            length,
            replacement_cost,
            rating,
            release_year,
            fulltext,
            _dlt_id
        from {{ ref('stg_pagila__film') }}
    ),
    stg_pagila__film_category as (
        select film_id, category from {{ ref('stg_pagila__film_category') }}
    ),
    stg_pagila__film__special_features as (
        select `_dlt_parent_id`, value
        from {{ ref('stg_pagila__film__special_features') }}
    ),
    film_genre as (
        select
            film_id,
            COUNT(case when category = 'Action' then 1 end) > 0 as genre_action,
            COUNT(case when category = 'Animation' then 1 end) > 0 as genre_animation,
            COUNT(case when category = 'Children' then 1 end) > 0 as genre_children,
            COUNT(case when category = 'Classics' then 1 end) > 0 as genre_classics,
            COUNT(case when category = 'Comedy' then 1 end) > 0 as genre_comedy,
            COUNT(case when category = 'Documentary' then 1 end)
            > 0 as genre_documentary,
            COUNT(case when category = 'Drama' then 1 end) > 0 as genre_drama,
            COUNT(case when category = 'Family' then 1 end) > 0 as genre_family,
            COUNT(case when category = 'Foreign' then 1 end) > 0 as genre_foreign,
            COUNT(case when category = 'Games' then 1 end) > 0 as genre_games,
            COUNT(case when category = 'Horror' then 1 end) > 0 as genre_horror,
            COUNT(case when category = 'Music' then 1 end) > 0 as genre_music,
            COUNT(case when category = 'New' then 1 end) > 0 as genre_new,
            COUNT(case when category = 'Sci-Fi' then 1 end) > 0 as genre_sci_fi,
            COUNT(case when category = 'Sports' then 1 end) > 0 as genre_sports,
            COUNT(case when category = 'Travel' then 1 end) > 0 as genre_travel
        from stg_pagila__film_category
        group by film_id
    ),
    film_feature as (
        select
            _dlt_parent_id,
            COUNT(case when value = 'Deleted Scenes' then 1 end)
            > 0 as feat_deleted_scenes,
            COUNT(case when value = 'Behind the Scenes' then 1 end)
            > 0 as feat_behind_the_scenes,
            COUNT(case when value = 'Trailers' then 1 end) > 0 as feat_trailers,
            COUNT(case when value = 'Commentaries' then 1 end) > 0 as feat_commentairies
        from stg_pagila__film__special_features
        group by _dlt_parent_id
    ),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key(['film.film_id']) }} as film_key,
            film.film_id,
            film.title,
            film.description,
            film.language,
            film.original_language,
            film.rental_duration,
            film.rental_rate,
            film.length,
            film.replacement_cost,
            film.rating,
            film.release_year,
            film.fulltext,
            COALESCE(genre.genre_action, FALSE) as genre_action,
            COALESCE(genre.genre_animation, FALSE) as genre_animation,
            COALESCE(genre.genre_children, FALSE) as genre_children,
            COALESCE(genre.genre_classics, FALSE) as genre_classics,
            COALESCE(genre.genre_comedy, FALSE) as genre_comedy,
            COALESCE(genre.genre_documentary, FALSE) as genre_documentary,
            COALESCE(genre.genre_drama, FALSE) as genre_drama,
            COALESCE(genre.genre_family, FALSE) as genre_family,
            COALESCE(genre.genre_foreign, FALSE) as genre_foreign,
            COALESCE(genre.genre_games, FALSE) as genre_games,
            COALESCE(genre.genre_horror, FALSE) as genre_horror,
            COALESCE(genre.genre_music, FALSE) as genre_music,
            COALESCE(genre.genre_new, FALSE) as genre_new,
            COALESCE(genre.genre_sci_fi, FALSE) as genre_sci_fi,
            COALESCE(genre.genre_sports, FALSE) as genre_sports,
            COALESCE(genre.genre_travel, FALSE) as genre_travel,
            COALESCE(feat.feat_deleted_scenes, FALSE) as feat_deleted_scenes,
            COALESCE(feat.feat_behind_the_scenes, FALSE) as feat_behind_the_scenes,
            COALESCE(feat.feat_trailers, FALSE) as feat_trailers,
            COALESCE(feat.feat_commentairies, FALSE) as feat_commentairies,
            now() as __etl_processed_at
        from stg_pagila__film as film
        left join film_genre as genre on film.film_id = genre.film_id
        left join film_feature as feat on film.`_dlt_id` = feat.`_dlt_parent_id`
    )
select *
from final
