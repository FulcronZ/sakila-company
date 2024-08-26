with
    dim_store as (select store_key from {{ ref('dim_store') }}),
    dim_date as (select date_key from {{ ref('dim_date') }}),
    dim_customer as (
        select
            store_key, customer_id, create_date, country, city, district, postal_code,
        from {{ ref('dim_customer') }}
    ),
    store_agg as (
        select
            toUInt32(formatDateTime(create_date, '%Y%m%d')) as date_key,
            store_key,
            country,
            city,
            district,
            postal_code,
            COUNT(DISTINCT customer_id) as customers
        from dim_customer
        group by store_key, date_key, country, city, district, postal_code
    ),
    final as (
        select
            {{ dbt_utils.generate_surrogate_key([
                'dd.date_key',
                'store.store_key',
                'agg.country',
                'agg.city',
                'agg.district',
                'agg.postal_code'
            ]) }} as fact_key,
            dd.date_key as date_key,
            store.store_key as store_key,
            COALESCE(agg.country, 'N/A') as country,
            COALESCE(agg.city, 'N/A') as city,
            COALESCE(agg.district, 'N/A') as district,
            COALESCE(agg.postal_code, 'N/A') as postal_code,
            COALESCE(agg.customers, 0) as customers,
            now() as __etl_processed_at
        from dim_store as store
        cross join dim_date as dd
        left join
            store_agg as agg
            on store.store_key = agg.store_key
            and dd.date_key = agg.date_key
        where dd.date_key >= 20200101  -- Use date spine from 1 Jan 2020
    )

select *
from final
