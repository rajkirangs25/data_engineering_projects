-- STORAGE INTEGRATION
CREATE STORAGE INTEGRATION IF NOT EXISTS olist_s3_storage_integration
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_ALLOWED_LOCATIONS = ('s3://s3-olist-raj/source/')
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::540361297412:role/olist_role';

SHOW STORAGE INTEGRATIONS;

DESC INTEGRATION olist_s3_storage_integration;

-- FILE FORMAT
CREATE OR REPLACE FILE FORMAT olist_csv_file_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    TIMESTAMP_FORMAT = 'AUTO'
    NULL_IF = ('', 'NULL', 'null');

SHOW FILE FORMATS;

-- STAGE
CREATE OR REPLACE STAGE olist_staging
    URL = 's3://s3-olist-raj/source/'
    STORAGE_INTEGRATION = olist_s3_storage_integration
    FILE_FORMAT = olist_csv_file_format;

SHOW STAGES;