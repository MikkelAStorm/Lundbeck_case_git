select
	sales_id,
	month,
	market_code,
	geography_id,
	coalesce(product_id, 'UNATTRIBUTED') as product_id,
	units,
	net_sales_local,
	currency_code,
	loaded_at
from {{ ref('stg_sales__transactions') }}
