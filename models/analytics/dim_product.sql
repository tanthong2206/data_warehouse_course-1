WITH dim_product__source AS (
  SELECT 
    *
  FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`
)

,dim_product__rename_column AS (
  SELECT 
     stock_item_id AS product_key
    ,stock_item_name  AS product_name
    ,brand AS brand_name
    ,supplier_id AS supplier_key
  FROM dim_product_source
)

, dim_product__cast_type AS (
  SELECT 
    cast(product_key AS integer) AS product_key
    ,cast(product_name AS string) AS product_name
    ,cast(brand_name AS string) AS brand_name
    ,cast(supplier_key AS integer) AS supplier_key
  FROM dim_product__rename_column
)

SELECT 
  dim_product.product_key
  ,dim_product.product_name
  ,dim_product.brand_name
  ,dim_product.supplier_key
  ,dim_supplier.supplier_name
FROM dim_product__cast_type AS dim_product
LEFT JOIN {{ref('dim_supplier')}} AS dim_supplier
  ON dim_product.supplier_key = dim_supplier.supplier_key