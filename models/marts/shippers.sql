{{
config({
    "post-hook": [
    "{{ primary_key(this, 'shipper_key' )}}",
    ],
    })
}}

with

shippers as (
    select * from {{ref('stg_northwind__shippers')}}
),


final as (
    select
        {{
            dbt_utils.generate_surrogate_key([
                'shipper_id',
                ])
        }} as shipper_key,
        shipper_id,
        shipper
    from shippers
)

select * from final
