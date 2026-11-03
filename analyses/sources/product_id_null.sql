
with sales as (
    select *
        from {{ ref('stg_sales__transactions') }}
)

, no_product as (
    select *
    from sales
    where product_id is NULL
)

-- There are no duplicate sales_id that reference the same product sold in the same location, so they are probably not duplicated sales.
select *
from no_product
order by sales_id