WITH fact_sales_order__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__orders`
)

, fact_sales_order__rename_column AS (
SELECT 
  order_id AS sales_order_key
  ,customer_id  AS customer_key
  ,picked_by_person_id AS picked_by_person_key
  ,order_date
FROM fact_sales_order__source
)

, fact_sales_order__cast_type AS (
  SELECT 
    cast(sales_order_key as integer) as sales_order_key
    ,cast(customer_key as integer) as customer_key
    ,cast(picked_by_person_key as integer) as picked_by_person_key
    ,cast(order_date as date) as order_date
  FROM fact_sales_order__rename_column
)
SELECT
  sales_order_key
  ,customer_key
  ,COALESCE(picked_by_person_key,0) AS picked_by_person_key
  ,order_date
FROM fact_sales_order__cast_type
