with

source as (
    select * from {{source('northwind', 'order_details')}}
),

conversion as (
    select
    order_id,
    product_id,
    unit_price::float8::numeric::money,
    quantity,
    discount
    from source
),

final as (
    select * from conversion 
)

select * from final
