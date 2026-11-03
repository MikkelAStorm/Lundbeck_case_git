# Synthetic commercial data dictionary

All data is fictional. `market_code` is DE/FR/JP; local currency EUR/EUR/JPY. No exchange rates are provided.

| File | Grain | Fields |
|---|---|---|
| sales_transactions.csv | One source sales transaction (some revisions/duplicate IDs) | sales_id, month (YYYY-MM-01), market_code, geography_id, product_id, units (negative indicates return), net_sales_local, currency_code, loaded_at |
| crm_interactions.csv | One interaction | interaction_id, interaction_date, market_code, geography_id, product_id, hcp_id (synthetic), channel, interaction_status |
| product_master.csv | One fictional product | product_id, product_name, therapeutic_area, brand_family, launch_year |
| geography_master.csv | One fictional geography/territory | geography_id, market_code, region_name, territory_name, currency_code |

Business rules to consider: `Completed` interactions count as completed activities; sales returns are legitimate negative quantities. Different currencies must not be summed as though equivalent. Data may include invalid identifiers, repeated sales IDs and late-loaded corrections. Treat dates as synthetic. A commercial relationship is not evidence of causal effect.

Expected outputs: monthly product/market sales performance, year-over-year unit comparison, and CRM activity trends without accidental many-to-many joins. State your decisions for invalid records and revisions.
