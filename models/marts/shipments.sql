{{
config({
    "post-hook": [
    "{{ primary_key(this, 'shipment_key')}}",
      "{{ foreign_key(this, 'customer_key', ref('customers'), 'customer_key')}}",
      "{{ foreign_key(this, 'employee_key', ref('employees'), 'employee_key')}}",
      "{{ foreign_key(this, 'shipper_key', ref('shippers'), 'shipper_key')}}",
      "{{ foreign_key(this, 'order_details_key', ref('order_details'), 'order_details_key')}}",
    ],
    })
}}
with

source as (
    select
        order_id,
        customer_id,
        employee_id,
        shipper_id,
        shipped_date,
        delay,
        freight
    from {{ref('stg_northwind__orders')}}
),

customers as (
    select
    customer_key,
    customer_id
    from {{ref('customers')}}
),

order_details as (
    select
    order_details_key,
    order_id
    from {{ref('order_details')}}
),

shippers as (
    select
    shipper_key,
    shipper_id
    from {{ref('shippers')}}
),

employees as (
    select
    employee_key,
    employee_id
    from {{ ref('employees') }}
),

final as (
    select
    -- keys
    {{ dbt_utils.generate_surrogate_key([
        'order_details.order_details_key',
        'customers.customer_key',
        'shippers.shipper_key',
        'employees.employee_key',
        'source.shipped_date'
        ])
    }} as shipment_key, 
    order_details.order_details_key,
    customers.customer_key,
    shippers.shipper_key,
    employees.employee_key,
    
    -- alternate keys
    source.order_id,
    source.customer_id,
    source.shipper_id,
    source.employee_id,
    source.shipped_date,
    source.delay,
    source.freight

    from source
    left join order_details on order_details.order_id = source.order_id
    left join shippers on shippers.shipper_id = source.shipper_id
    left join customers on customers.customer_id = source.customer_id
    left join employees on employees.employee_id = source.employee_id

)

select * from final
