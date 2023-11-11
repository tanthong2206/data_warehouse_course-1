WITH fact_sales_order_line__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__order_lines`
)

, fact_sales_order_line__rename_column AS (
SELECT 
  order_line_id  AS sales_order_line_key
  ,order_id AS sales_order_key
  ,stock_item_id  AS product_key
  ,quantity  AS quantity
  ,unit_price  AS unit_price
  ,quantity  * unit_price  AS gross_amount
FROM fact_sales_order_line__source
)

, fact_sales_order_line__cast_type AS (
  SELECT 
    cast(sales_order_line_key as integer) AS sales_order_line_key
    ,cast(sales_order_key as integer) as sales_order_key
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
   fact_line.sales_order_line_key
  ,fact_line.sales_order_key
  ,fact_line.product_key
  ,fact_header.customer_key
  ,fact_header.picked_by_person_key
  ,fact_line.quantity
  ,fact_line.unit_price
  ,fact_line.gross_amount
FROM fact_sales_order_line__calculated_measure fact_line
LEFT JOIN {{ref('stg_fact_sales_order')}} fact_header
  ON fact_line.sales_order_key = fact_header.sales_order_key
