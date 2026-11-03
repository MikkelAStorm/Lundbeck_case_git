select
    interaction_id,
    interaction_date,
    market_code,
    geography_id,
    product_id,
    hcp_id,
    channel,
    interaction_status
from {{ source('raw', 'crm_interactions') }}