"""
kaggle_to_s3.py
---------------
Fetches the Olist Brazilian E-Commerce dataset from Kaggle
and uploads all CSVs to an S3 bucket — no manual steps required.

Requirements:
    pip install kaggle boto3 python-dotenv

Setup:
    1. Create a .env file with:
       export KAGGLE_USERNAME="your_username"
       export KAGGLE_KEY="your_api_key"
       export AWS_ACCESS_KEY_ID="your_aws_key"
       export AWS_SECRET_ACCESS_KEY="your_aws_secret"
       export AWS_DEFAULT_REGION="us-east-1"
    2. Run: python kaggle_to_s3.py --bucket your-bucket-name --prefix source/
"""
# ── Load .env ─────────────────────────────────────────────────────────────────
from pathlib import Path
from dotenv import load_dotenv
load_dotenv(dotenv_path=Path(__file__).resolve().parent.parent / ".env")

# ── Packages ─────────────────────────────────────────────────────────────────
import os
import zipfile
import logging
import argparse

import boto3
from kaggle.api.kaggle_api_extended import KaggleApi

# ── Config ────────────────────────────────────────────────────────────────────

DATASET_SLUG = "olistbr/brazilian-ecommerce"
DOWNLOAD_DIR = Path("/tmp/olist_data")
S3_PREFIX    = "source/"          # folder path inside the bucket

# ── Logging ───────────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger(__name__)

# ── Helpers ───────────────────────────────────────────────────────────────────

def download_from_kaggle(dest: Path) -> Path:
    """Download and unzip the dataset into dest/. Returns the dest path."""
    dest.mkdir(parents=True, exist_ok=True)

    log.info("Authenticating with Kaggle API …")
    api = KaggleApi()
    api.authenticate()

    log.info(f"Downloading dataset '{DATASET_SLUG}' …")
    api.dataset_download_files(DATASET_SLUG, path=str(dest), unzip=False)

    zip_path = dest / "brazilian-ecommerce.zip"
    log.info(f"Unzipping {zip_path} …")
    with zipfile.ZipFile(zip_path, "r") as z:
        z.extractall(dest)

    zip_path.unlink()   # remove the zip to save space
    log.info("Download and extraction complete.")
    return dest


def upload_to_s3(src_dir: Path, bucket: str, prefix: str) -> None:
    """Upload every CSV in src_dir to s3://bucket/prefix/."""
    s3 = boto3.client("s3")
    csv_files = list(src_dir.rglob("*.csv"))

    if not csv_files:
        log.warning("No CSV files found — nothing uploaded.")
        return

    log.info(f"Uploading {len(csv_files)} file(s) to s3://{bucket}/{prefix}")
    for local_path in csv_files:
        s3_key = prefix + local_path.name
        log.info(f"  {local_path.name} → s3://{bucket}/{s3_key}")
        s3.upload_file(str(local_path), bucket, s3_key)

    log.info("All files uploaded successfully.")


# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Fetch Olist dataset and push to S3.")
    parser.add_argument("--bucket",  required=True, help="Target S3 bucket name")
    parser.add_argument("--prefix",  default=S3_PREFIX, help=f"S3 key prefix (default: {S3_PREFIX})")
    parser.add_argument("--keep",    action="store_true", help="Keep local files after upload")
    args = parser.parse_args()

    try:
        data_dir = download_from_kaggle(DOWNLOAD_DIR)
        upload_to_s3(data_dir, bucket=args.bucket, prefix=args.prefix)
    finally:
        if not args.keep:
            import shutil
            shutil.rmtree(DOWNLOAD_DIR, ignore_errors=True)
            log.info("Local temp files removed.")


if __name__ == "__main__":
    main()