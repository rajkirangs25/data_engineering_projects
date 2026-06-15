WITH dates AS (
    SELECT DISTINCT
        CAST(order_purchase_timestamp AS DATE) AS full_date
    FROM {{ ref('stg_orders') }}
    WHERE order_purchase_timestamp IS NOT NULL
)
SELECT
    TO_NUMBER(TO_CHAR(full_date, 'YYYYMMDD'))   AS date_id,
    full_date,
    YEAR(full_date)                              AS year,
    MONTH(full_date)                             AS month,
    MONTHNAME(full_date)                         AS month_name,
    DAY(full_date)                               AS day,
    DAYOFWEEK(full_date)                         AS day_of_week,
    DAYNAME(full_date)                           AS day_name,
    QUARTER(full_date)                           AS quarter,
    CASE WHEN DAYOFWEEK(full_date) IN (1,7) 
         THEN TRUE ELSE FALSE END                AS is_weekend
FROM dates