CREATE OR REPLACE TABLE order_items (
    order_id            VARCHAR NOT NULL,
    order_item_id       NUMBER  NOT NULL,
    product_id          VARCHAR,
    seller_id           VARCHAR,
    shipping_limit_date TIMESTAMP_NTZ,
    price               FLOAT,
    freight_value       FLOAT,
    PRIMARY KEY (order_id, order_item_id)
);