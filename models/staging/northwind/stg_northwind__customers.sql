with

source as (
    select * from {{source('northwind', 'customers')}}
),

rename as (
    select 
      -- ids
      customer_id,

      -- strings
      company_name as customer,
      contact_name,
      contact_title,
      address,
      city,
      region,
      postal_code,
      country,
      phone,
      fax
    from source
),

final as (
    select * from rename
)

select * from final

