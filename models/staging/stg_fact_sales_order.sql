WITH fact_sales_orders__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__orders`
)

, fact_sales_orders__rename_column AS (
SELECT 
  order_id AS sales_order_key
  ,customer_id  AS customer_key
FROM fact_sales_orders__source
)

, fact_sales_orders__cast_type AS (
  SELECT 
    cast(sales_order_key as integer) as sales_order_key
    ,cast(customer_key as integer) as customer_key
  FROM fact_sales_orders__rename_column
)
SELECT
  sales_order_key
  ,customer_key
 
FROM fact_sales_orders__cast_type
