WITH dim_supplier__source AS (
SELECT 
  *
FROM `vit-lam-data.wide_world_importers.purchasing__suppliers`
)

, dim_supplier__rename_column AS (
  SELECT
    supplier_id AS supplier_key
    ,supplier_name AS supplier_name
  FROM dim_supplier__source
)

, dim_supplier__cast_type AS (
  SELECT
    cast(supplier_key AS integer) AS supplier_key
    ,cast(supplier_name as string) AS supplier_name
  FROM dim_supplier__rename_column
)

, dim_supplier__add_undefined_record AS (
  SELECT
    supplier_key
    ,supplier_name
  FROM dim_supplier__cast_type
 
  UNION ALL 

  SELECT
  0 AS supplier_key
  , 'Undefined' supplier_name

  UNION ALL 

  
  SELECT
  -1 AS supplier_key
  , 'Invalid' AS supplier_name
)
SELECT
  supplier_key
  ,supplier_name
FROM dim_supplier__add_undefined_record