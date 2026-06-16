CREATE OR REPLACE TABLE sellers (
    seller_id               VARCHAR NOT NULL,
    seller_zip_code_prefix  VARCHAR,
    seller_city             VARCHAR,
    seller_state            VARCHAR,
    PRIMARY KEY (seller_id)
);