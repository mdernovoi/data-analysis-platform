import os
import sys

from minio import Minio
from minio.error import S3Error

from dotenv import load_dotenv
from pathlib import Path

mlflow_buckets=[
    "mlflow"
]

def get_minio_connection(endpoint: str,
                         secrets_file_name: str) -> Minio:
    
    # get credentials
    dotenv_path = Path(os.getenv('PLATFORM_PATH_SECRETS'), secrets_file_name)
    load_dotenv(dotenv_path=dotenv_path)

    client = Minio(
        endpoint=endpoint,
        secure=True,
        access_key=os.getenv('MINIO_ACCESS_KEY'),
        secret_key=os.getenv('MINIO_SECRET_KEY'),
    )

    return(client)

def create_buckets_if_not_exist(client: Minio,
                                bucket_names: list[str]) -> None:
    
    # Create buckets
    for bucket_name in bucket_names:

        bucket_exists = client.bucket_exists(bucket_name)
        if not bucket_exists:
            client.make_bucket(bucket_name)
        else:
            print(f"Bucket {bucket_name} already exists.")

def main(arguments: list) -> None:

    endpoint = arguments[1]

    client = get_minio_connection(endpoint = endpoint,
                                  secrets_file_name = "mlflow_MINIO_KEYS.env")
    create_buckets_if_not_exist(client = client,
                                bucket_names = mlflow_buckets)

    

if __name__ == "__main__":
    try:
        main(arguments=sys.argv)
    except Exception as exc:
        print("An error occurred: ", exc)
        raise