select
	sales.sales_id,
	sales.month,
	sales.market_code,
	sales.geography_id as source_geography_id,
	case
		when sales.geography_id is null then 'NOT_PROVIDED'
		when exists (
			select 1
			from {{ ref('dim_geography') }} as geography
			where geography.geography_id = sales.geography_id
		) then sales.geography_id
		else 'UNKNOWN'
	end as geography_id,
	sales.product_id as source_product_id,
	case
		when sales.product_id is null then 'UNATTRIBUTED'
		when exists (
			select 1
			from {{ ref('dim_product') }} as product
			where product.product_id = sales.product_id
		) then sales.product_id
		else 'UNKNOWN'
	end as product_id,
	sales.units,
	sales.net_sales_local,
	sales.currency_code,
	sales.loaded_at
from {{ ref('stg_sales__transactions') }} as sales
