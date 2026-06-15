WITH ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY customer_id) AS rn
    FROM {{ ref('stg_customers') }}
)
SELECT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state,
    customer_zip_code_prefix
FROM ranked
WHERE rn = 1