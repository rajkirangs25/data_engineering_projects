SELECT
    prod.product_id                                             AS product_id,
    prod.product_category_name                                  AS product_category_name,
    trans.product_category_name_english                         AS product_category_name_english,
    prod.product_name_length                                    AS product_name_length,
    prod.product_description_length                             AS product_description_length,
    prod.product_photos_qty                                     AS product_photos_qty,
    prod.product_weight_g                                       AS product_weight_g,
    prod.product_length_cm                                      AS product_length_cm,
    prod.product_height_cm                                      AS product_height_cm,
    prod.product_width_cm                                       AS product_width_cm
FROM
    {{ ref('stg_products') }}                                   AS prod
LEFT JOIN
    {{ ref('stg_product_category_name_translation') }}          AS trans
ON
    prod.product_category_name = trans.product_category_name