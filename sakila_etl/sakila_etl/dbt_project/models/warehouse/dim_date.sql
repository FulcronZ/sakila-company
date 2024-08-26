with
    date_spine as (
        {{
            dbt_utils.date_spine(
                datepart="day",
                start_date="toDate('1970-01-01')",
                end_date="toDate('2100-01-01')"
            )
        }}
    ),
    final as (
        select
            toUInt32(formatDateTime(date_day, '%Y%m%d')) as date_key,
            date_day as full_date,
            toYear(date_day) as year,
            toQuarter(date_day) as quarter,
            toMonth(date_day) as month,
            toDayOfMonth(date_day) as day,
            formatDateTime(date_day, '%W') as day_of_week,
            toDayOfWeek(date_day) between 6 and 7 as is_weekend,
            now() as __etl_processed_at
        from date_spine
    )
select *
from final
