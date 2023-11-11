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
    ,is_chiller_stock as is_chiller_stock_boolean
    ,supplier_id AS supplier_key
  FROM dim_product__source
)

, dim_product__cast_type AS (
  SELECT 
    cast(product_key AS integer) AS product_key
    ,cast(product_name AS string) AS product_name
    ,cast(brand_name AS string) AS brand_name
    ,cast(is_chiller_stock_boolean as boolean) as is_chiller_stock_boolean
    ,cast(supplier_key AS integer) AS supplier_key
  FROM dim_product__rename_column
)

, dim_product__convert_boolean AS (
  SELECT 
    *
    ,CASE
      WHEN is_chiller_stock_boolean IS TRUE then 'Chiller Stock'
      WHEN is_chiller_stock_boolean IS FALSE then 'Not Chiller Stock'
      WHEN is_chiller_stock_boolean IS NULL then 'Undefined' --du lieu bi trong hoac null
      ELSE 'Invalid' END --data bi sai
     AS is_chiller_stock
  FROM dim_product__cast_type
)
SELECT 
  dim_product.product_key
  ,dim_product.product_name
  ,COALESCE(dim_product.brand_name,'Undefined') AS brand_name
  ,dim_product.is_chiller_stock
  ,dim_product.supplier_key
  ,dim_supplier.supplier_name
FROM dim_product__convert_boolean AS dim_product
LEFT JOIN {{ref('dim_supplier')}} AS dim_supplier
  ON dim_product.supplier_key = dim_supplier.supplier_key