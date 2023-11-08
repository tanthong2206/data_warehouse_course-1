WITH dim_customer__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS (
  SELECT
    customer_id AS customer_key
    ,customer_name
    , customer_category_id AS customer_category_key
    , buying_group_id AS buying_group_key
  FROM dim_customer__source
)

, dim_customer__cast_type AS (
  SELECT
    CAST(customer_key as integer) as customer_key
    ,CAST(customer_name as string) as customer_name
    , CAST(customer_category_key AS integer) AS customer_category_key
    , CAST(buying_group_key AS integer) AS buying_group_key
  FROM dim_customer__rename_column
)

SELECT
  dim_customer.customer_key
  ,dim_customer.customer_name
  ,dim_customer.customer_category_key
  ,dim_customer_category.customer_category_name
  ,dim_customer.buying_group_key
  ,dim_buying_group.buying_group_name
FROM dim_customer__cast_type AS dim_customer
LEFT JOIN {{ref('stg_dim_customer_category')}} AS dim_customer_category 
  ON dim_customer.customer_category_key = dim_customer_category.customer_category_key
LEFT JOIN {{ref('stg_dim_buying_group')}} AS dim_buying_group
  ON dim_customer.buying_group_key = dim_buying_group.buying_group_key
