{{ config(materialized='table') }}

with generated_date_dimension as (

    {{
        dbt_date.get_date_dimension(
            var('dim_dato_start_date', '2000-01-01'),
            var('dim_dato_end_date', '2100-01-01')
        )
    }}

)

select
    date_day,
    month_start_date,
    dateadd(month, -1, month_start_date) as prior_month_start_date,
    month_name_short,
    month_of_year,
    year_number,
    concat(to_char(date_day, 'YY'), '-', month_name_short) as month_label,
    to_char(date_day, 'YYYY') as year_label
from generated_date_dimension