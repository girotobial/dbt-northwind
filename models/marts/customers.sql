{{
config({
    "post-hook": [
      "{{ primary_key(this, 'customer_key' )}}",
    ],
    })
}}

with

customers as (
    select * from {{ref('stg_northwind__customers')}}
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key([
                'customer_id', 'customer'
                ])
        }} as customer_key,
        customer_id,
        customer,
        contact_name,
        contact_title,
        address,
        city,
        postal_code,
        country
    from customers
)

select * from final
