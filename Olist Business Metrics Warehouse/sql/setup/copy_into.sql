-- COPYing from S3 to Snowflake
-- customers
COPY INTO customers
    FROM @olist_staging
    FILES = ('olist_customers_dataset.csv');

SELECT * FROM customers;

-- geolocation
COPY INTO geolocation
    FROM @olist_staging
    FILES = ('olist_geolocation_dataset.csv');

SELECT * FROM geolocation;

-- order_items
COPY INTO order_items
    FROM @olist_staging
    FILES = ('olist_order_items_dataset.csv');

SELECT * FROM order_items;

-- order_payments
COPY INTO order_payments
    FROM @olist_staging
    FILES = ('olist_order_payments_dataset.csv');

SELECT * FROM order_payments;

-- order_reviews
COPY INTO order_reviews
    FROM @olist_staging
    FILES = ('olist_order_reviews_dataset.csv');

SELECT * FROM order_reviews;

-- orders
COPY INTO orders
    FROM @olist_staging
    FILES = ('olist_orders_dataset.csv');
    
SELECT * FROM orders;

-- products
COPY INTO products
    FROM @olist_staging
    FILES = ('olist_products_dataset.csv');

SELECT * FROM products;

-- sellers
COPY INTO sellers
    FROM @olist_staging
    FILES = ('olist_sellers_dataset.csv');

SELECT * FROM sellers;

-- product_category_name_translation
COPY INTO product_category_name_translation
    FROM @olist_staging
    FILES = ('product_category_name_translation.csv');

SELECT * FROM product_category_name_translation;