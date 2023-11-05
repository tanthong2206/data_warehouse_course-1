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
    cast(sales_order_line_key as integer) AS sales_order_line_key
    ,cast(product_key as integer) AS product_key
    ,cast(quantity as integer) AS quantity
    ,cast(unit_price as numeric) AS unit_price
  FROM fact_sales_order_line__rename_column
)

, fact_sales_order_line__calculated_measure AS (
SELECT 
   *
  ,unit_price * quantity as gross_amount
FROM fact_sales_order_line__cast_type
)

SELECT 
   sales_order_line_key
  ,product_key
  ,quantity
  ,unit_price
  ,gross_amount
FROM fact_sales_order_line__calculated_measure
