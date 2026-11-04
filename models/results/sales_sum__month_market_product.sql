with monthly_sales as (

    select
        month_label,
        market_code,
        product_id,
        product_name,
        currency_code,
        sum(units) as units,
        sum(net_sales_local) as net_sales_local
    from {{ ref('sales_OBT') }}
    group by
        month_label,
        market_code,
        product_id,
        product_name,
        currency_code
)

select 
    month_label,
    market_code,
    product_name,
    units,
    net_sales_local,
    currency_code,
from monthly_sales