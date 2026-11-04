with prod1 as(
    select 
        month_label,
        product_id,
        units,
        market_code 
    from {{ ref('sales_sum__month_market_product') }}
    where product_id = 'P0001' 
)

, DE as (
    select * from prod1
    where market_code = 'DE'
)
, FR as (
    select * from prod1
    where market_code = 'FR'
)
, JP as (
    select * from prod1
    where market_code = 'JP'
)

select
    de.month_label,
    de.product_id,
    de.units as de,
    fr.units as fr,
    jp.units as jp
from DE as de
join FR as fr on de.month_label = fr.month_label
join JP as jp on de.month_label = jp.month_label