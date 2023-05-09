{{
config({
    "post-hook": [
      "{{ primary_key(this, 'product_key' )}}",
    ],
    })
}}
with

products as (
    select * from {{ ref('stg_northwind__products')}}
),

suppliers as (
    select * from {{ ref('stg_northwind__suppliers')}} 
),

categories as (
    select * from {{ ref('stg_northwind__categories')}} 
),

final as (
    select
        {{
            dbt_utils.generate_surrogate_key([
                'products.product_id',
                'suppliers.supplier_id',
                'categories.category_id',
                ])
        }} as product_key,
        products.product_id,
        products.product,
        products.unit_price,
        products.discontinued,
        products.supplier_id,
        suppliers.supplier_name,
        suppliers.supplier_city,
        suppliers.supplier_region,
        suppliers.supplier_country,
        categories.category_id,
        categories.product_category

    from products
    left join suppliers on products.supplier_id = suppliers.supplier_id
    left join categories on products.category_id = categories.category_id
)

select * from final
