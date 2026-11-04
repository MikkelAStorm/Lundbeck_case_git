with monthly_sales as (

    select
        month_start_date,
        prior_month_start_date,
        month_label,
        year_label,
        market_code,
        product_id,
        product_name,
        currency_code,
        sum(units) as units,
        sum(net_sales_local) as net_sales_local
    from {{ ref('sales_OBT') }}
    group by
        month_start_date,
        prior_month_start_date,
        month_label,
        year_label,
        market_code,
        product_id,
        product_name,
        currency_code

), month_over_month as (

    select
        current_month.month_start_date,
        current_month.prior_month_start_date,
        current_month.month_label,
        current_month.year_label,
        current_month.market_code,
        current_month.product_id,
        current_month.product_name,
        current_month.currency_code,
        current_month.units,
        prior_month.units as prior_month_units,
        current_month.units - prior_month.units as units_change_vs_last_month,
        100.0 * (current_month.units - prior_month.units)
            / nullif(prior_month.units, 0) as units_change_pct_vs_last_month,
        current_month.net_sales_local,
        prior_month.net_sales_local as prior_month_net_sales_local,
        current_month.net_sales_local - prior_month.net_sales_local
            as net_sales_local_change_vs_last_month,
        100.0 * (current_month.net_sales_local - prior_month.net_sales_local)
            / nullif(prior_month.net_sales_local, 0) as net_sales_local_change_pct_vs_last_month
    from monthly_sales as current_month
    left join monthly_sales as prior_month
        on prior_month.month_start_date = current_month.prior_month_start_date
        and prior_month.market_code is not distinct from current_month.market_code
        and prior_month.product_id is not distinct from current_month.product_id
        and prior_month.currency_code is not distinct from current_month.currency_code
)

select *
from month_over_month