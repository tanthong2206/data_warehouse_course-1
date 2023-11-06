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

SELECT
  supplier_key
  ,supplier_name
FROM dim_supplier__cast_type