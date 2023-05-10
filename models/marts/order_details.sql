{{
config({
    "post-hook": [
      "{{ primary_key(this, 'order_details_key' )}}",
    ],
    })
}}
with

source as (
    select * from {{ ref('stg_northwind__orders') }}
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key([
                'order_id',
                ])
        }} as order_details_key,
    order_id,
    lead_time,
    fulfillment_time,
    delay,
    ship_name,
    ship_address,
    ship_city,
    ship_region,
    ship_country

    from source
)

select * from final
