select
    sales_id,
    month,
    market_code,
    geography_id,
    product_id,
    units,
    net_sales_local,
    currency_code,
    loaded_at
from {{ source('raw', 'sales_transactions') }}