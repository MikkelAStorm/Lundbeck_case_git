select
    geography_id,
    market_code,
    region_name,
    territory_name,
    currency_code
from {{ ref('stg_geography__master') }}