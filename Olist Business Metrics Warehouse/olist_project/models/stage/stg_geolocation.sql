SELECT
    geolocation_zip_code_prefix,
    geolocation_lat AS geolocation_latitude,
    geolocation_lng AS geolocation_longitude,
    geolocation_city,
    geolocation_state
FROM
    {{ source('raw', 'geolocation') }}