with geographies as (

    select
        geography_id,
        market_code,
        region_name,
        territory_name,
        currency_code
    from {{ ref('stg_geography__master') }}
    where geography_id is not null
        and geography_id not in ('UNKNOWN', 'NOT_PROVIDED')

)

select
    geography_id,
    market_code,
    region_name,
    territory_name,
    currency_code
from geographies

union all

select
    'UNKNOWN' as geography_id,
    null as market_code,
    'Unknown region' as region_name,
    'Unknown territory' as territory_name,
    null as currency_code

union all

select
    'NOT_PROVIDED' as geography_id,
    null as market_code,
    'Not provided' as region_name,
    'Not provided' as territory_name,
    null as currency_code