{{
config({
    "post-hook": [
    "{{ primary_key(this, 'order_key')}}",
      "{{ foreign_key(this, 'customer_key', ref('customers'), 'customer_key')}}",
      "{{ foreign_key(this, 'employee_key', ref('employees'), 'employee_key')}}",
      "{{ foreign_key(this, 'product_key', ref('products'), 'product_key')}}",
      "{{ foreign_key(this, 'shipper_key', ref('shippers'), 'shipper_key')}}",
    ],
    })
}}
with

orders as (
    select * from {{ref('stg_northwind__orders')}}
),
order_details as (
    select * from {{ref('stg_northwind__order_detail')}}
),

orders_joined as (
    select
    {{ dbt_utils.generate_surrogate_key([
        'orders.order_id', 
        'orders.customer_id',
        'orders.employee_id',
        'd.product_id',
        'orders.shipper_id'
        ])
    }} as order_key, 
    -- ids
    orders.order_id,
    orders.customer_id,
    orders.employee_id,
    orders.shipper_id,
    d.product_id,

    -- dates
    orders.order_date,
    orders.required_date,
    orders.shipped_date,
    
    -- pricing
    d.unit_price,
    d.discount,
    d.quantity,

    -- calculated
    (unit_price * quantity) as total_price,
    ((1 - discount) * unit_price * quantity) as total_less_discount,
    (discount * unit_price * quantity) as discount_amount

    from orders
    left join order_details as d
    on d.order_id = orders.order_id
),

products as (
    select * from {{ref('products')}}
),

shippers as (
    select * from {{ref('shippers')}}
),

customers as (
    select * from {{ref('customers')}}
),

employees as (
    select * from {{ref('employees')}}
),

final as (
    select
        -- surrogate keys
        oj.order_key,
        products.product_key,
        shippers.shipper_key,
        customers.customer_key,
        employees.employee_key,
        
        -- alternate keys
        oj.order_id,
        oj.customer_id,
        oj.employee_id,
        oj.product_id,
        oj.shipper_id,
        
        -- data
        oj.order_date,
        oj.required_date,
        oj.shipped_date,
        
        oj.unit_price,
        oj.discount,
        oj.quantity,

        oj.total_price,
        oj.total_less_discount,
        oj.discount_amount

    from orders_joined as oj 
    left join products on products.product_id = oj.product_id
    left join shippers on shippers.shipper_id = oj.shipper_id
    left join customers on customers.customer_id = oj.customer_id
    left join employees on employees.employee_id = oj.employee_id
)

select * from final 
