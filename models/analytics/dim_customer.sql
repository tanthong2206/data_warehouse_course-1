WITH dim_customer__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS (
  SELECT
    customer_id AS customer_key
    ,customer_name
  FROM dim_customer__source
)

, dim_customer__cast_type AS (
  SELECT
    cast(customer_key as integer) as customer_key
    ,cast(customer_name as string) as customer_name
  FROM dim_customer__rename_column
)

SELECT
  customer_key
  ,customer_name
FROM dim_customer__cast_type
