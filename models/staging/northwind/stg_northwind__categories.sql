with

source as (
    select * from {{ source('northwind', 'categories')}}
),

renamed as (
    select
        -- ids
        category_id,

        --strings
        category_name as category,
        description
        picture

    from source
),

final as (
    select * from renamed
)

select * from final
