# Synthetic commercial data dictionary

All data is fictional. `market_code` is DE/FR/JP; local currency EUR/EUR/JPY. No exchange rates are provided.

## dbt model inventory

The project is organized into three layers:

| Layer | Model | Grain | Purpose |
|---|---|---|---|
| staging | `stg_sales__transactions` | One raw sales row | Keeps the source transaction facts and load metadata intact |
| staging | `stg_crm__interactions` | One raw CRM interaction | Keeps the raw interaction facts and statuses intact |
| staging | `stg_product__master` | One product | Provides the product master dimension |
| staging | `stg_geography__master` | One geography/territory | Provides the geography master dimension |
| marts | `dim_date` | One calendar date | Supports reporting dates and month-level joins |
| marts | `dim_product` | One product key | Standardizes valid and missing product identifiers |
| marts | `dim_geography` | One geography key | Standardizes valid and missing geography identifiers |
| marts | `fct_sales` | One sales transaction | Normalizes sales keys and retains raw values for audit |
| marts | `fct_crm` | One CRM interaction | Normalizes CRM keys and flags completed interactions |
| results | `sales_OBT` | One month / market / product / currency aggregation | Reusable sales output table |
| results | `crm_sales_obt` | One month / market / geography / product / currency panel | CRM and sales activity panel for analysis |
| results | `sales_aggregate__annual_market_product` | One market / product / currency / year summary | Annual unit and revenue comparison |
| results | `sales_sum__month_market_product` | One month / market / product / currency comparison | Month-over-month trend view |

A traditional intermediate/Silver layer was not needed due to the high quality of the input data. Most was almost ready for mart/Gold layer from the source. 

## Source file fields

| File | Grain | Fields |
|---|---|---|
| sales_transactions.csv | One source sales transaction (some revisions/duplicate IDs) | sales_id, month (YYYY-MM-01), market_code, geography_id, product_id, units (negative indicates return), net_sales_local, currency_code, loaded_at |
| crm_interactions.csv | One interaction | interaction_id, interaction_date, market_code, geography_id, product_id, hcp_id (synthetic), channel, interaction_status |
| product_master.csv | One fictional product | product_id, product_name, therapeutic_area, brand_family, launch_year |
| geography_master.csv | One fictional geography/territory | geography_id, market_code, region_name, territory_name, currency_code |

Business rules to consider: `Completed` interactions count as completed activities; sales returns are legitimate negative quantities. Different currencies must not be summed as though equivalent. Data may include invalid identifiers, repeated sales IDs and late-loaded corrections. Treat dates as synthetic. A commercial relationship is not evidence of causal effect.

Expected outputs: monthly product/market sales performance, year-over-year unit comparison, and CRM activity trends without accidental many-to-many joins. State your decisions for invalid records and revisions.
