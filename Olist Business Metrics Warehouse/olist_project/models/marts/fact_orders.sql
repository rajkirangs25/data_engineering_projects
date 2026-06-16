WITH payments AS (
    SELECT
        order_id,
        SUM(payment_value)  AS payment_value,
        MAX(payment_type)   AS payment_type
    FROM {{ ref('stg_order_payments') }}
    GROUP BY order_id
)

SELECT
    soi.order_id,
    soi.order_item_id,
    so.customer_id,
    soi.product_id,
    soi.seller_id,
    dd.date_id,
    so.order_status,
    so.order_purchase_timestamp,
    so.order_delivered_customer_date,
    so.order_estimated_delivery_date,
    soi.price,
    soi.freight_value,
    p.payment_value,
    p.payment_type,
    sor.review_score
FROM
    {{ ref('stg_order_items') }}    AS soi
JOIN
    {{ ref('stg_orders') }}         AS so
    ON soi.order_id = so.order_id
LEFT JOIN
    payments                        AS p
    ON soi.order_id = p.order_id
LEFT JOIN
    {{ ref('stg_order_reviews') }}  AS sor
    ON soi.order_id = sor.order_id
LEFT JOIN
    {{ ref('dim_date') }}           AS dd
    ON CAST(so.order_purchase_timestamp AS DATE) = dd.full_date