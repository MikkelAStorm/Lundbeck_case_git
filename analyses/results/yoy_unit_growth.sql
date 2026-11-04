select *
from {{ ref('sales_aggregate__annual_market_product') }}
where units_growth_rank_2025_vs_2023 <= 2 or units_growth_rank_2025_vs_2023 >= 500
order by units_growth_rank_2025_vs_2023