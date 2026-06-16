"""
olist_pipeline.py
-----------------
Airflow DAG that orchestrates the full Olist data pipeline:
1. Kaggle → S3         (@task)
2. S3 → Snowflake      (@task)
3. dbt run             (BashOperator)
4. dbt test            (BashOperator)

Schedule: daily at midnight
"""

from datetime import datetime, timedelta
from pathlib import Path

from airflow.decorators import dag, task
from airflow.providers.standard.operators.bash import BashOperator

import os
import sys

sys.path.insert(0, "/opt/airflow/dags")

DBT_DIR = "/opt/airflow/olist_project"

# ── DAG ───────────────────────────────────────────────────────────────────────

@dag(
    dag_id="olist_pipeline",
    description="Olist end-to-end data pipeline: Kaggle → S3 → Snowflake → dbt",
    start_date=datetime(2024, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    tags=["olist", "etl"],
)
def olist_pipeline():

    # ── Task 1: Kaggle → S3 ───────────────────────────────────────────────────

    @task()
    def kaggle_to_s3():
        from s3_ingestion import download_from_kaggle, upload_to_s3

        bucket  = os.environ["S3_BUCKET"]
        prefix  = os.environ.get("S3_PREFIX", "source/")

        data_dir = download_from_kaggle(Path("/tmp/olist_data"))
        upload_to_s3(data_dir, bucket=bucket, prefix=prefix)

        import shutil
        shutil.rmtree("/tmp/olist_data", ignore_errors=True)

    # ── Task 2: Schemas Creation ───────────────────────────────────────────────────

    @task()
    def create_schemas():
        import snowflake.connector
        from pathlib import Path
        import os

        conn = snowflake.connector.connect(
            account=os.environ["SNOWFLAKE_ACCOUNT"],
            user=os.environ["SNOWFLAKE_USER"],
            password=os.environ["SNOWFLAKE_PASSWORD"],
            warehouse=os.environ["SNOWFLAKE_WAREHOUSE"],
            database=os.environ["SNOWFLAKE_DATABASE"],
        )

        sql = Path("/opt/airflow/sql/setup/create_schemas.sql").read_text()
        
        cursor = conn.cursor()
        for statement in sql.split(";"):
            statement = statement.strip()
            if statement:
                cursor.execute(statement)
        cursor.close()
        conn.close()

    # ── Task 3: Raw tables Creation ────────────────────────────────────────────────

    @task()
    def create_raw_tables():
        import snowflake.connector

        conn = snowflake.connector.connect(
            account   = os.environ["SNOWFLAKE_ACCOUNT"],
            user      = os.environ["SNOWFLAKE_USER"],
            password  = os.environ["SNOWFLAKE_PASSWORD"],
            warehouse = os.environ["SNOWFLAKE_WAREHOUSE"],
            database  = os.environ["SNOWFLAKE_DATABASE"],
            schema    = os.environ["SNOWFLAKE_SCHEMA"],
        )

        sql_dir = Path("/opt/airflow/sql/ddl")
        cursor = conn.cursor()
    
        for sql_file in sorted(sql_dir.glob("*.sql")):
            sql = sql_file.read_text()
            cursor.execute(sql)
    
        cursor.close()
        conn.close()

    # ── Task 4: S3 → Snowflake ────────────────────────────────────────────────

    @task()
    def s3_to_snowflake():
        import snowflake.connector

        conn = snowflake.connector.connect(
            account   = os.environ["SNOWFLAKE_ACCOUNT"],
            user      = os.environ["SNOWFLAKE_USER"],
            password  = os.environ["SNOWFLAKE_PASSWORD"],
            warehouse = os.environ["SNOWFLAKE_WAREHOUSE"],
            database  = os.environ["SNOWFLAKE_DATABASE"],
            schema    = os.environ["SNOWFLAKE_SCHEMA"],
        )

        sql = Path("/opt/airflow/sql/setup/copy_into.sql").read_text()
        cursor = conn.cursor()
        for statement in sql.split(";"):
            statement = statement.strip()
            if statement:
                cursor.execute(statement)
        cursor.close()
        conn.close()

    # ── Task 5: dbt run ───────────────────────────────────────────────────────

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_DIR} && dbt run --profiles-dir {DBT_DIR}",
    )

    # ── Task 6: dbt test ──────────────────────────────────────────────────────

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_DIR} && dbt test --profiles-dir {DBT_DIR}",
    )

    # ── Dependencies ──────────────────────────────────────────────────────────

    kaggle_to_s3() >> create_schemas() >> create_raw_tables() >> s3_to_snowflake() >> dbt_run >> dbt_test


olist_pipeline()