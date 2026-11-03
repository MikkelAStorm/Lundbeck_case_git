with sales as (

    select *
    from {{ ref('stg_sales__transactions') }}

)
, repeated_sales_ids as (
    select *
    from sales
    where sales_id in (
        select sales_id
        from sales
        group by sales_id
    having count(*) > 1
    )
    order by sales_id
)

, sales_quality_checks as (

    select
        sales_id,
        geography_id,
        month,

        count(*) as record_count,
        count(distinct product_id) as distinct_products,

        count(*) > 1 as multiple_records,
        count(distinct product_id) > 1 as multi_product_sale

    from repeated_sales_ids
    group by
        sales_id,
        geography_id,
        month

)

, flagged_sales as (

    select
        s.*,
        q.record_count,
        q.distinct_products,
        q.multiple_records,
        q.multi_product_sale

    from repeated_sales_ids s
    left join sales_quality_checks q
        on s.sales_id = q.sales_id
        and s.geography_id = q.geography_id
        and s.month = q.month

)

select *
from flagged_sales
where multiple_records
   or multi_product_sale
