
with sales as (
    select *
        from {{ ref('stg_sales__transactions') }}
)

, no_product as (
    select *
    from sales
    where product_id is NULL
)

-- I took a look at the sales with no product ID, but honestly do not have a lot to add. 
-- It is most likely to be a data error (maybe at data entry) for real sales so,
-- I will keep the sales in the analysis with an 'Unallocated Product' category.
select *
from no_product
order by sales_id