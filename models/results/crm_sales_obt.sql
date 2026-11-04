with monthly_crm as (

    select
        date_dim.month_start_date,
        coalesce(geography.market_code, crm.market_code) as market_code,
        crm.geography_id,
        crm.product_id,
        geography.currency_code,
        max(crm.interaction_id) as crm_id,
        sum(crm.interaction_count) as total_interactions,
        sum(crm.completed_interaction_count) as completed_interactions
    from {{ ref('fct_crm') }} as crm
    left join {{ ref('dim_date') }} as date_dim
        on date_dim.date_day = cast(crm.interaction_date as date)
    left join {{ ref('dim_geography') }} as geography
        on geography.geography_id = crm.geography_id
    where date_dim.month_start_date is not null
    group by
        date_dim.month_start_date,
        coalesce(geography.market_code, crm.market_code),
        crm.geography_id,
        crm.product_id,
        geography.currency_code

), monthly_sales as (

    select
        date_dim.month_start_date,
        coalesce(geography.market_code, sales.market_code) as market_code,
        sales.geography_id,
        sales.product_id,
        coalesce(geography.currency_code, sales.currency_code) as currency_code,
        max(sales.sales_id) as sales_id,
        sum(sales.units) as units,
        sum(sales.net_sales_local) as net_sales_local
    from {{ ref('fct_sales') }} as sales
    inner join {{ ref('dim_date') }} as date_dim
        on date_dim.date_day = sales.month
    left join {{ ref('dim_geography') }} as geography
        on geography.geography_id = sales.geography_id
    group by
        date_dim.month_start_date,
        coalesce(geography.market_code, sales.market_code),
        sales.geography_id,
        sales.product_id,
        coalesce(geography.currency_code, sales.currency_code)

), combined_monthly as (

    select
        coalesce(crm.month_start_date, sales.month_start_date) as month_start_date,
        coalesce(crm.market_code, sales.market_code) as market_code,
        coalesce(crm.geography_id, sales.geography_id) as geography_id,
        coalesce(crm.product_id, sales.product_id) as product_id,
        coalesce(crm.currency_code, sales.currency_code) as currency_code,
        crm.crm_id,
        sales.sales_id,
        coalesce(crm.total_interactions, 0) as total_interactions,
        coalesce(crm.completed_interactions, 0) as completed_interactions,
        coalesce(sales.units, 0) as units,
        coalesce(sales.net_sales_local, 0) as net_sales_local
    from monthly_crm as crm
    full outer join monthly_sales as sales
        on crm.month_start_date = sales.month_start_date
        and crm.market_code is not distinct from sales.market_code
        and crm.geography_id is not distinct from sales.geography_id
        and crm.product_id is not distinct from sales.product_id
        and crm.currency_code is not distinct from sales.currency_code

)

select
    combined.month_start_date,
    date_dim.month_label,
    date_dim.year_label,
    combined.market_code,
    combined.geography_id,
    geography.region_name,
    geography.territory_name,
    combined.product_id,
    combined.currency_code,
    combined.crm_id,
    combined.sales_id,
    combined.total_interactions,
    combined.completed_interactions,
    combined.units,
    combined.net_sales_local,
    dateadd(month, 1, combined.month_start_date) as next_month_start_date,
    coalesce(next_sales.units, 0) as next_month_units,
    coalesce(next_sales.net_sales_local, 0) as next_month_net_sales_local
from combined_monthly as combined
left join {{ ref('dim_date') }} as date_dim
    on date_dim.date_day = combined.month_start_date
left join {{ ref('dim_geography') }} as geography
    on geography.geography_id = combined.geography_id
left join monthly_sales as next_sales
    on next_sales.month_start_date = dateadd(month, 1, combined.month_start_date)
    and next_sales.market_code is not distinct from combined.market_code
    and next_sales.geography_id is not distinct from combined.geography_id
    and next_sales.product_id is not distinct from combined.product_id
    and next_sales.currency_code is not distinct from combined.currency_code