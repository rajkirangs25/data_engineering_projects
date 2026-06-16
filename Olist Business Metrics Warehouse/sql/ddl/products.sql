CREATE OR REPLACE TABLE products (
    product_id                  VARCHAR NOT NULL,
    product_category_name       VARCHAR,
    product_name_length         NUMBER,
    product_description_length  NUMBER,
    product_photos_qty          NUMBER,
    product_weight_g            FLOAT,
    product_length_cm           FLOAT,
    product_height_cm           FLOAT,
    product_width_cm            FLOAT,
    PRIMARY KEY (product_id)
);