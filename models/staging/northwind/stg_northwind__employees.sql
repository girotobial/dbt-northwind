with 

source as (
    select * from {{source('northwind', 'employees')}}
),

final as (
    select
    -- ids
      employee_id,
      reports_to,

      -- string
      last_name,
      first_name,
      (first_name || ' ' || last_name) as full_name,
      title,
      title_of_courtesy,
      address,
      city,
      region,
      postal_code,
      country,
      home_phone,
      extension,
      notes,
      photo_path,

      -- date
      birth_date,
      hire_date,

      -- image
      photo

    from source
)

select * from final
