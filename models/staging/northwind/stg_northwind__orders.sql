with

source as (
    select * from {{source('northwind', 'orders')}}
),

recalculated as (
    select
        -- ids
        order_id,
        customer_id,
        employee_id,

        -- dates
        order_date,
        required_date,
        shipped_date,

        (required_date - order_date) as lead_time,
        (shipped_date - order_date) as fulfillment_time,
        (shipped_date - required_date) as delay,

        -- strings
        ship_name,
        ship_address,
        ship_city,
        ship_region,
        ship_postal_code,
        ship_country,

        -- numeric
        ship_via,
        freight
    from source
),

final as (
    select * from recalculated 
)

select * from final

