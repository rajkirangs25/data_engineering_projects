{{ config(materialized = 'incremental') }}

SELECT *
FROM {{ source('staging','hosts') }}
{% if is_incremental() %}
    WHERE CREATED_AT > (SELECT MAX(CREATED_AT) FROM {{ this }})
{% endif %}