select
    d.month_label,
    geo.market_code,
    prod.product_name,
    sales.currency_code,
    sum(sales.units) as units,
    sum(sales.net_sales_local) as net_sales_local,
    d.date_day
from {{ ref('fct_sales') }} as sales
join {{ ref('dim_geography') }} as geo
    on geo.geography_id = sales.geography_id
join {{ ref('dim_product') }} as prod
    on prod.product_id = sales.product_id
join {{ ref('dim_date') }} as d
    on d.date_day = sales.month
group by
    d.month_label,
    geo.market_code,
    prod.product_name,
    sales.currency_code,
    d.date_day
order by
    prod.product_name,
    geo.market_code,
    d.date_day,
    sales.currency_code