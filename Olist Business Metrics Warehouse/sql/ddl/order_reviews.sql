CREATE OR REPLACE TABLE order_reviews (
    review_id               VARCHAR NOT NULL,
    order_id                VARCHAR,
    review_score            NUMBER,
    review_comment_title    VARCHAR,
    review_comment_message  VARCHAR,
    review_creation_date    TIMESTAMP_NTZ,
    review_answer_timestamp TIMESTAMP_NTZ,
    PRIMARY KEY (review_id)
);