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
  ,unit_price  AS unit_price
  ,quantity  * unit_price  AS gross_amount
FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT 
    cast(order_line_id as integer) AS sales_order_line_key
    ,cast(stock_item_id as integer) AS product_key
    ,cast(quantity as integer) AS quantity
    ,cast(unit_price as numeric) AS unit_price
    ,cast(quantity as integer) * cast(unit_price as numeric) AS gross_amount
  FROM fact_sales_order_line__rename_column

)
SELECT 
   sales_order_line_key
  ,product_key
  ,quantity
  ,unit_price
  ,gross_amount
FROM fact_sales_order_line__cast_type
