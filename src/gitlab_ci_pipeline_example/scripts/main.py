

########
# EXECUTION: python3 scripts/main.py https://mlflow.my-project-domain.com https://minio.my-project-domain.com
########

import os
import sys
import logging

import mlflow

from dotenv import load_dotenv
from pathlib import Path

def main (arguments: list) -> None:

    # Configure mlflow and minio
    mlflow_url = arguments[1]
    minio_url = arguments[2] 

    # Files with mlflow secrets.
    # They have to be uploaded as a "secure file" to gitlab: settings --> ci --> secure files
    # Reference the secrets folder
    dotenv_path = Path("secrets", "mlflow_MINIO_KEYS.env")
    load_dotenv(dotenv_path=dotenv_path)
    dotenv_path = Path("secrets", "mlflow_BASIC_AUTHENTICATION.env")
    load_dotenv(dotenv_path=dotenv_path)

    mlflow.set_tracking_uri(mlflow_url)
    mlflow.set_experiment("test_experiment_gitlab")

    # configure minio (bject storage) for mlflow artifact storage
    os.environ['MLFLOW_S3_ENDPOINT_URL'] = minio_url
    os.environ['AWS_ACCESS_KEY_ID'] = os.getenv('MINIO_ACCESS_KEY')
    os.environ['AWS_SECRET_ACCESS_KEY'] = os.getenv('MINIO_SECRET_KEY')

    # Execute mlflow experiment
    with mlflow.start_run():
        # log some stuff
        mlflow.log_param('alpha', 2)
        mlflow.log_param('l1_ratio', "some value")
        mlflow.log_metric('rmse', 0.007)
        mlflow.log_artifact(local_path = 'requirements.txt')


if __name__ == "__main__":

    logging.getLogger().setLevel(logging.INFO)
    logging.info("Starting main script...")

    main(arguments=sys.argv)

    
