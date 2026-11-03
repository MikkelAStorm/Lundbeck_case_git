
with sales as (
    select *
        from {{ ref('stg_sales__transactions') }}
)

, multi_product_sales as (
    select *
    from sales
    where sales_id in (
        select sales_id
        from sales
        group by sales_id, geography_id, month
    having count(*) > 1
    )
)

, duplicated_sales as (
    select *
    from sales
    where sales_id in (
        select sales_id
        from sales
        group by sales_id, product_id, units
    having count(*) > 1
    )
)

, flagged_sales as (
    select
        s.*,
        exists (
            select 1
            from multi_product_sales m
            where m.sales_id = s.sales_id
        ) as multi_product,
        exists (
            select 1
            from duplicated_sales d
            where d.sales_id = s.sales_id
        ) as duplicated_sales
    from sales s
)

select *
from flagged_sales
where multi_product or duplicated_sales
order by sales_id
