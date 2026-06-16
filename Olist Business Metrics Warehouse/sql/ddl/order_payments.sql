CREATE OR REPLACE TABLE order_payments (
    order_id             VARCHAR NOT NULL,
    payment_sequential   NUMBER,
    payment_type         VARCHAR,
    payment_installments NUMBER,
    payment_value        FLOAT
);