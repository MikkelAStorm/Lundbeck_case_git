# Lundbeck Commercial dbt Project

dbt project for exploring synthetic commercial sales and CRM activity in Snowflake. The project keeps transaction and interaction facts separate, then aggregates them at explicit time, market, geography, product, and currency grains for analysis.

## Requirements

- dbt CLI 2.x with the Snowflake adapter.
- A dbt CLI connection to the Snowflake Partner Connect Trial project.
- Read access to `LUNDBECK.RAW` and write access to the project schemas configured below.
- The raw tables `SALES_TRANSACTIONS`, `CRM_INTERACTIONS`, `PRODUCT_MASTER`, and `GEOGRAPHY_MASTER` in `LUNDBECK.RAW`.

Do not commit passwords, tokens, private keys, or other credentials. Configure them in the local dbt profile or environment variables.

## Set Up

From the repository root:

```shell
dbt deps
dbt debug
dbt parse
```

`dbt deps` installs `godatadriven/dbt_date` as pinned in `packages.yml`. `dbt debug` checks the local profile and Snowflake connection. If it fails, verify that the profile name is `default`, the Snowflake account/role/warehouse are correct, and the role can access the raw tables and create objects in the configured schemas.

## Build and Test

Build the project models and run their configured tests:

```shell
dbt build
```

To build the CRM/sales OBT and its upstream models only:

```shell
dbt build --select +crm_sales_obt
```

Run the fact and dimension key tests directly:

```shell
dbt test --select 'fct_sales fct_crm dim_product dim_geography dim_date'
```

Preview a model without materializing it:

```shell
dbt show --select crm_sales_obt --limit 10
dbt show --select sales_sum__month_market_product --limit 10
```

The SQL files under `analyses/` are analytical queries rather than materialized models. Compile one with:

```shell
dbt compile --select crm_sales__correlation
```

## Project Layout

- `models/staging/`: thin views over the four Snowflake raw sources.
- `models/marts/`: date, geography, and product dimensions plus the sales and CRM facts.
- `models/results/`: reusable OBTs and monthly/annual sales result models.
- `analyses/results/`: exploratory queries, including CRM/sales correlation and year-over-year unit growth.
- `DATA_DICTIONARY.md`: source grains, columns, and business rules.
- `models/**/*.yml`: dbt schema and model documentation for staging, mart, and result layers.

The project targets database `LUNDBECK`. Staging models use the custom schema `BRONZE` and are views; marts use `GOLD` and are tables; results use `GOLD_VIEWS` and are views. dbt's default schema naming can prefix these custom schemas with the profile's target schema, so the final schema name depends on the local profile configuration.

## Data Conventions

- Only CRM interactions with status `Completed` count as completed activities.
- Negative sales units are legitimate returns and are retained.
- Local-currency sales are grouped by currency and must not be summed across currencies.
- Null product IDs map to `UNATTRIBUTED`; unmatched non-null product or geography IDs map to `UNKNOWN`, while missing geography IDs map to `NOT_PROVIDED`. Original source IDs are retained due to the high quality input.
- Repeated sales IDs are retained. All duplicated sales IDs seem to relate to compleatly different sales, so no canonical revision winner is defined yet.
- CRM interactions are correlated to both positive and negative net-value sales, as it is unclear wheather the interactions are only relating to new sales or long term customer relations. 
