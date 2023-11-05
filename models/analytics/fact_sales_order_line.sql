WITH fact_sales_order_line__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
SELECT 
  order_line_id  AS sales_order_line_key
  ,stock_item_id  AS product_key
  ,quantity  AS quantity
  ,unit_price as numeric) AS unit_price
  ,quantity  * unit_price  AS gross_amount
FROM fact_sales_order_line__source
)
SELECT 
  cast(order_line_id as integer) as sales_order_line_key
  ,cast(stock_item_id as integer) as product_key
  ,cast(quantity as integer) as quantity
  ,cast(unit_price as numeric) as unit_price
  ,cast(quantity as integer) * cast(unit_price as numeric) as gross_amount
FROM fact_sales_order_line__rename_column
