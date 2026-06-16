CREATE OR REPLACE TABLE orders (
    order_id                      VARCHAR NOT NULL,
    customer_id                   VARCHAR,
    order_status                  VARCHAR,
    order_purchase_timestamp      TIMESTAMP_NTZ,
    order_approved_at             TIMESTAMP_NTZ,
    order_delivered_carrier_date  TIMESTAMP_NTZ,
    order_delivered_customer_date TIMESTAMP_NTZ,
    order_estimated_delivery_date TIMESTAMP_NTZ,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);