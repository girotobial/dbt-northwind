
with 
source as (
    select * from {{ source('northwind', 'suppliers') }}
),

renamed as (
    select 
    
        --ids
        supplier_id,

        -- strings
        company_name as supplier,
        contact_name,
        contact_title,
        address,
        city,
        region,
        postal_code,
        country,
        phone,
        fax,
        homepage
    from source
),

final as (
    select * from renamed
)

select * from final
