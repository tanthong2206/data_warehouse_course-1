WITH dimp_product_source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`
)
,dim_product_rename_column AS (
  SELECT 
     stock_item_id AS product_key
    ,stock_item_name  AS product_name
    ,brand AS brand_name
  FROM dimp_product_source
)
, dim_product_cast_type AS (
  SELECT 
    cast(product_key AS integer) AS product_key
    ,cast(product_name AS string) AS product_name
    ,cast(brand_name AS string) AS brand_name
  FROM dim_product_rename_column
)

SELECT 
  product_key
  ,product_name
  ,brand_name
FROM dim_product_cast_type