CREATE OR REPLACE TABLE customers(
    customer_id                 VARCHAR NOT NULL,
    customer_unique_id          VARCHAR,
    customer_zip_code_prefix    VARCHAR,
    customer_city               VARCHAR,
    customer_state              VARCHAR,
    PRIMARY KEY (customer_id)
);