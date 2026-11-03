select *
from {{ ref('sales_annual__market_product') }}
where units_growth_rank_2025_vs_2024 <= 2