with products as (

    select
        product_id,
        product_name,
        therapeutic_area,
        brand_family,
        launch_year
    from {{ ref('stg_product__master') }}

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
    'UNATTRIBUTED' as product_id,
    'unattributed product' as product_name,
    null as therapeutic_area,
    null as brand_family,
    null as launch_year