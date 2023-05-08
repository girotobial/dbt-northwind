with

source as (
    select * from {{source('northwind', 'order_details')}}

),

final as (
    select * from source
)

select * from final
