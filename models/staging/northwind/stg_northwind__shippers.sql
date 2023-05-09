with

shippers as (
    select * from {{source('northwind', 'shippers')}}
),

rename as (
    select
        shipper_id,
        company_name as shipper,
        phone
    from shippers
),

final as (
    select * from rename
)

select * from final
