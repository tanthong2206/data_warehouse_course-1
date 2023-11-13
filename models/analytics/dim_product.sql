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

, dim_product__add_undefined_record AS (
  SELECT
    product_key
    ,product_name
    ,brand_name
    ,is_chiller_stock
    ,supplier_key
  FROM dim_product__convert_boolean
 
  UNION ALL 

  SELECT
  0 AS product_key
  , 'Undefined' AS product_name
  , 'Undefined' AS brand_name
  , 'Undefined' AS is_chiller_stock
  ,0 AS supplier_key

  UNION ALL 

  
  SELECT
  -1 AS product_key
  , 'Invalid' AS product_name
  , 'Invalid' AS brand_name
  , 'Invalid' AS is_chiller_stock
  ,-1 AS supplier_key
)
SELECT 
  dim_product.product_key
  ,dim_product.product_name
  ,COALESCE(dim_product.brand_name,'Undefined') AS brand_name
  ,dim_product.is_chiller_stock
  ,dim_product.supplier_key
  ,COALESCE(dim_supplier.supplier_name,'Invalid') AS supplier_name --xu ly null left join khi data co trong bang product nhung bang supplier chua co
FROM dim_product__add_undefined_record AS dim_product
LEFT JOIN {{ref('dim_supplier')}} AS dim_supplier
  ON dim_product.supplier_key = dim_supplier.supplier_key