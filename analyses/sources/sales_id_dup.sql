
with sales as (
    select *
        from {{ ref('stg_sales__transactions') }}
)

, duplicated_sales as (
    select *
    from sales
    where sales_id in (
        select sales_id
        from sales
        group by sales_id
    having count(*) > 1
    )
)

select *
from duplicated_sales
order by sales_id