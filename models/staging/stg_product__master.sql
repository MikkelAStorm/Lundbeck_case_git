select
    product_id,
    product_name,
    therapeutic_area,
    brand_family,
    launch_year
from {{ source('raw', 'product_master') }}