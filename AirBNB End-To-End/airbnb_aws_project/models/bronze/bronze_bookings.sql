{{ config(materialized = 'incremental') }}

SELECT * 
FROM {{ source('staging','bookings') }}
{% if is_incremental() %}
    WHERE CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}