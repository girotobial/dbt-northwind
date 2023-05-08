with

source as (
    select * from {{ source('northwind', 'products') }}
),

renamed as (
    select 
        -- ids
        product_id,
        supplier_id,
        category_id,

        -- strings
        product_name as product,
        quantity_per_unit,
        
        -- numerics
        unit_price,
        units_in_stock,
        units_on_order,
        reorder_level,
        discontinued 
    from source

),

final as (
    select * from renamed
)

select * from final

