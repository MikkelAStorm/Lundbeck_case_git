with annual_sales as (

    select
        year(date_day) as sales_year,
        market_code,
        product_id,
        product_name,
        currency_code,
        sum(units) as units,
        sum(net_sales_local) as net_sales_local
    from {{ ref('sales_aggregate__market_product_month') }}
    group by
        year(date_day),
        market_code,
        product_id,
        product_name,
        currency_code

), annual_columns as (

    select
        market_code,
        product_id,
        product_name,
        currency_code,
        sum(case when sales_year = 2023 then units end) as units_2023,
        sum(case when sales_year = 2024 then units end) as units_2024,
        sum(case when sales_year = 2025 then units end) as units_2025,
        sum(case when sales_year = 2023 then net_sales_local end) as net_sales_local_2023,
        sum(case when sales_year = 2024 then net_sales_local end) as net_sales_local_2024,
        sum(case when sales_year = 2025 then net_sales_local end) as net_sales_local_2025
    from annual_sales
    group by
        market_code,
        product_id,
        product_name,
        currency_code

), unit_changes as (

    select
        *,
        units_2024 - units_2023 as units_change_2024_vs_2023,
        100.0 * (units_2024 - units_2023) / nullif(units_2023, 0) as units_change_pct_2024_vs_2023,
        units_2025 - units_2024 as units_change_2025_vs_2024,
        100.0 * (units_2025 - units_2024) / nullif(units_2024, 0) as units_change_pct_2025_vs_2024
    from annual_columns

)

select
    *,
    rank() over (
        partition by market_code
        order by units_change_2025_vs_2024 desc nulls last
    ) as units_growth_rank_2025_vs_2024,
    rank() over (
        partition by market_code
        order by units_change_2025_vs_2024 asc nulls last
    ) as units_decline_rank_2025_vs_2024
from unit_changes
order by
    units_growth_rank_2025_vs_2024 asc nulls last,
    market_code,
    product_name