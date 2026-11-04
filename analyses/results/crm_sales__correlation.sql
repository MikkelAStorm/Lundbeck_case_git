
select
    market_code,
    currency_code,
    count(*) as geography_count,
    sum(completed_interactions) as completed_interactions,
    corr(completed_interactions, units) as same_month_units_correlation,
    corr(completed_interactions, net_sales_local) as same_month_net_sales_correlation,
    corr(completed_interactions, next_month_units) as next_month_units_correlation,
    corr(completed_interactions, next_month_net_sales_local) as next_month_net_sales_correlation
from {{ ref('crm_sales_obt') }}
group by
    market_code,
    currency_code