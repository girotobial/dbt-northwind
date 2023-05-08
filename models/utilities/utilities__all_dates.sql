with 

final as (
    {{dbt_utils.date_spine(
        datepart="day",
        start_date="cast('1980-01-01' as date)",
        end_date="cast('2042-01-01' as date)"
    )}}
)

select * from final
