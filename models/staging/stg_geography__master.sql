select
    geography_id,
    market_code,
    region_name,
    territory_name,
    currency_code
from {{ source('raw', 'geography_master') }}