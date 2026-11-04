select
    crm.interaction_id,
    crm.interaction_date,
    crm.market_code,
    crm.geography_id as source_geography_id,
    case
        when crm.geography_id is null then 'NOT_PROVIDED'
        when exists (
            select 1
            from {{ ref('dim_geography') }} as geography
            where geography.geography_id = crm.geography_id
        ) then crm.geography_id
        else 'UNKNOWN'
    end as geography_id,
    crm.product_id as source_product_id,
    case
        when crm.product_id is null then 'UNATTRIBUTED'
        when exists (
            select 1
            from {{ ref('dim_product') }} as product
            where product.product_id = crm.product_id
        ) then crm.product_id
        else 'UNKNOWN'
    end as product_id,
    crm.hcp_id,
    crm.channel,
    crm.interaction_status,
    1 as interaction_count,
    case
        when crm.interaction_status = 'Completed' then 1
        else 0
    end as completed_interaction_count
from {{ ref('stg_crm__interactions') }} as crm