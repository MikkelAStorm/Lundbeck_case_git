select
    crm.interaction_id,
    crm.interaction_date,
    crm.market_code,
    crm.geography_id,
    coalesce(crm.product_id, 'UNATTRIBUTED') as product_id,
    crm.hcp_id,
    crm.channel,
    crm.interaction_status,
    1 as interaction_count,
    case
        when crm.interaction_status = 'Completed' then 1
        else 0
    end as completed_interaction_count
from {{ ref('stg_crm__interactions') }} as crm