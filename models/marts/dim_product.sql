with products as (

    select
        product_id,
        product_name,
        therapeutic_area,
        brand_family,
        launch_year
    from {{ ref('stg_product__master') }}
    where product_id is not null
        and product_id not in ('UNKNOWN', 'UNATTRIBUTED')

)

select
    product_id,
    product_name,
    therapeutic_area,
    brand_family,
    launch_year
from products

union all

select
    'UNKNOWN' as product_id,
    'unknown product' as product_name,
    null as therapeutic_area,
    null as brand_family,
    null as launch_year

union all

select
    'UNATTRIBUTED' as product_id,
    'unattributed product' as product_name,
    null as therapeutic_area,
    null as brand_family,
    null as launch_year