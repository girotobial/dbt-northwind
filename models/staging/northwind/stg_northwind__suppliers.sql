
with 
source as (
    select * from {{ source('northwind', 'suppliers') }}
),

renamed as (
    select 
    
        --ids
        supplier_id,

        -- strings
        company_name as supplier_name,
        contact_name,
        contact_title,
        address,
        city as supplier_city,
        region as supplier_region,
        postal_code as supplier_postal_code,
        country as supplier_country,
        phone,
        fax,
        homepage
    from source
),

final as (
    select * from renamed
)

select * from final
