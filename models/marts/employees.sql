with

employees as (
    select * from {{ref('stg_northwind__employees')}}
),

managers as (
    select employee_id, full_name from employees
),


employees_with_managers as (
    select
        e.employee_id,
        e.full_name,
        e.title,
        e.city,
        e.region,
        e.country,
        managers.full_name as reports_to
    from
        employees as e
    left join managers
        on e.reports_to = managers.employee_id
),

final as (
    select * from employees_with_managers
)

select * from final
